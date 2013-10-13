# PicturehouseUk

A simple gem to parse the [Picturehouse Cinemas UK website][http://picturehouses.co.uk] and spit out useful formatted info.

[![Code Climate](https://codeclimate.com/github/andycroll/picturehouse_uk.png)](https://codeclimate.com/github/andycroll/picturehouse_uk)

## Installation

Add this line to your application's Gemfile:

    gem 'picturehouse_uk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install picturehouse_uk

## Usage

### Cinema

``` ruby
PicturehouseUK::Cinema.all
#=> [<PicturehouseUK::Cinema brand="Picturehouse" name="Duke's At Komedia" slug="dukes-at-komedia" chain_id="Dukes_At_Komedia" url="...">, #=> <PicturehouseUK::Cinema brand="Picturehouse" name="Duke o York's" slug="duke-of-yorks" chain_id="Duke_Of_Yorks" url="...">, ...]

PicturehouseUK::Cinema.find_by_id('Duke_Of_Yorks')
#=> <PicturehouseUK::Cinema brand="Picturehouse" name="Duke_Of_Yorks" slug="duke-of-yorks" address="..." chain_id="Duke_Of_Yorks" url="...">

cinema = PicturehouseUK::Cinema.find_by_slug('duke-of-yorks')
#=> <PicturehouseUK::Cinema brand="Picturehouse" name="Duke_Of_Yorks" slug="duke-of-yorks" address="..." chain_id="Duke_Of_Yorks" url="...">

cinema.brand
#=> 'Picturehouse'

cinema.chain_id
#=> 'Duke_Of_Yorks'

cinema.url
#=> "http://www.picturehouses.co.uk/cinema/Duke_Of_Yorks/"

cinema.films
#=> [<PicturehouseUK::Film name="Iron Man 3">, <PicturehouseUK::Film name="Star Trek: Into Darkness">]

cinema.screenings
#=> [<PicturehouseUK::Screening film="About Time" when="2013-09-09 11:00 UTC" varient="3d">, <PicturehouseUK::Screening film="Iron Man 3" when="2013-09-09 13:50 UTC" varient="kids">, <PicturehouseUK::Screening ..>, <PicturehouseUK::Screening ...>]

cinema.screenings_of 'Iron Man 3'
#=> [<PicturehouseUK::Screening film="Iron Man 3" when="2013-09-09 11:00 UTC" varient="3d">, <PicturehouseUK::Screening film="Iron Man 3" when="2013-09-09 13:50 UTC" varient="kids">]

cinema.screenings_of <PicturehouseUK::Film name="Iron Man 3">
#=> [<PicturehouseUK::Screening film="Iron Man 3" when="2013-09-09 11:00 UTC" varient="3d">, <PicturehouseUK::Screening film="Iron Man 3" when="2013-09-09 13:50 UTC" varient="kids">]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
