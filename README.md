# PicturehouseUk

A simple gem to pull cinemas and performances from the Vista API behind the [Picturehouse website](https://www.picturehouses.com) and spit out useful formatted info.

[![Gem Version](https://badge.fury.io/rb/picturehouse_uk.svg)](https://badge.fury.io/rb/picturehouse_uk)

## Installation

Add this line to your application's Gemfile:

    gem 'picturehouse_uk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install picturehouse_uk

## Usage

The gem conforms to the API set down in the `cinebase` gem, [andycroll/cinebase](https://github.com/andycroll/cinebase), which provides a lot of useful base vocabulary and repetitive code for this series of cinema focussed gems.

Performance titles are sanitized as much as possible, removing 'screening type' information, years, Q&A add-ons and festival prefixes, and standardising theatre and opera event naming.

### Guest token

Every API call needs the public guest token the Picturehouse ticketing site
gives each visitor. Fetch one before anything else:

``` ruby
PicturehouseUk.acquire_token!
PicturehouseUk::Cinema.all
```

This shells out to **`curl-impersonate`**, not ordinary system `curl`, using its
Chrome 150 TLS/HTTP profile, and reads `gasToken` from the page data of
`https://web.picturehouses.com/`. No browser or JavaScript execution is needed.

Platform-specific gem packages include the pinned `curl-impersonate` 2.2.3
executable for glibc Linux (x86-64, ARM64) and macOS (Intel, Apple Silicon).
On other platforms, or when installing from Git, install a
[curl-impersonate release](https://github.com/lexiforest/curl-impersonate/releases/tag/v2.2.3)
yourself and put it on your `PATH` or pass its path:

``` ruby
PicturehouseUk.acquire_token!(curl: '/opt/curl-impersonate/curl-impersonate')
```

Or supply your own current guest JWT, without the `Bearer ` prefix:

``` ruby
PicturehouseUk.token = ENV.fetch('PICTUREHOUSE_TOKEN')
```

Tokens currently last 12 hours. The gem checks the declared expiry but does not
verify the signature. Normal API calls never acquire or renew a token
automatically. `PicturehouseUk.ensure_token!` fetches one only when there is no
token, or the token expires within an hour, and otherwise keeps the current one.
Call it before each batch of requests:

``` ruby
PicturehouseUk.ensure_token!
PicturehouseUk.token_expires_at
#=> 2026-10-31 03:00:00 UTC
PicturehouseUk::Cinema.all
```

Missing, expired or rejected tokens raise `PicturehouseUk::AuthenticationError`. A
token the API rejects is cleared from `PicturehouseUk.token`, so the next
`ensure_token!` fetches a fresh one.

### Cinema

Cinema ids are Vista site ids. Duke's at Komedia is `'019'`.

``` ruby
PicturehouseUk::Cinema.all
#=> [<PicturehouseUk::Cinema ...>, <PicturehouseUk::Cinema ...>, ...]

cinema = PicturehouseUk::Cinema.new(19)
#=> <PicturehouseUk::Cinema ...>

cinema.adr
#=> {
  street_address:   '44-47 Gardner Street',
  extended_address: nil,
  locality:         'Brighton',
  region:           nil,
  postal_code:      'BN1 1UN',
  country_name:     'United Kingdom'
}

cinema.brand
#=> 'Picturehouse'

cinema.name
#=> "Duke's at Komedia"

cinema.latitude
#=> 50.8247985839844

cinema.longitude
#=> -0.139400005340576

cinema.id
#=> '019'

cinema.url
#=> 'https://www.picturehouses.com/cinema/duke-s-at-komedia'
```

### Performances

`Performance.at` returns performances for an inclusive range of business dates,
defaulting to today in London and the following 13 days. It makes one request
per day.

``` ruby
PicturehouseUk::Performance.at(19, from: Date.today, to: Date.today + 2)
#=> [<PicturehouseUk::Performance ...>, <PicturehouseUk::Performance ...>, ...]

performance = PicturehouseUk::Performance.at(19).first
#=> <PicturehouseUk::Performance ...>

performance.film_name
#=> 'Sense and Sensibility'

performance.film_year
#=> 2026 # from the title, nil when it has no year

performance.dimension
#=> '2d'

performance.variant
#=> ['audio_described', 'subtitled']

performance.subtitled?
#=> true

performance.festival
#=> #<data Cinebase::Festival name="CFF", year=2026> # nil outside festivals

performance.starting_at
#=> 2026-10-23 15:00:00 UTC

performance.booking_url
#=> 'https://web.picturehouses.com/order/showtimes/019-41632/seats'

performance.cinema_name
#=> "Duke's at Komedia"

performance.cinema_id
#=> '019'
```

Variants are `arts`, `audio_described`, `baby`, `kids`, `q&a`, `relaxed`,
`senior` and `subtitled`. Picturehouse doesn't tag audio languages, so
`language` is always `nil`.

## Tests

```sh
bundle exec rake          # unit tests against fixtures
bundle exec rake live     # live API, needs curl-impersonate or PICTUREHOUSE_TOKEN
```

Fixtures in `test/fixtures/api` are hand-written: invented films and
addresses in the shape of Vista responses, never recorded API output.
`test/support/api_shapes.rb` describes the fields the gem reads. The unit suite
checks the fixtures against it and the live suite checks real responses, held
only in memory. When the API changes, update the shape first, then the fixtures.

## Building release packages

```sh
bundle exec rake build         # Portable source gem; external curl-impersonate required
bundle exec rake package:all   # Four platform gems with bundled executables
```

To release, bump the version, merge, then run the **Release Gem** workflow in
GitHub Actions. It builds the source and four platform gems, publishes them
through RubyGems trusted publishing (no MFA code needed) and tags the release.
Versions already on RubyGems are skipped, so a failed run can be rerun.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
