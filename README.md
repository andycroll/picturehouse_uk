# PicturehouseUk

A simple gem to parse the [Picturehouse Cinemas UK website](http://picturehouses.co.uk) and spit out useful formatted info.

[![Gem Version](https://badge.fury.io/rb/picturehouse_uk.png)](http://badge.fury.io/rb/picturehouse_uk)
[![Code Climate](https://codeclimate.com/github/andycroll/picturehouse_uk.png)](https://codeclimate.com/github/andycroll/picturehouse_uk)
[![Build Status](https://travis-ci.org/andycroll/picturehouse_uk.png?branch=master)](https://travis-ci.org/andycroll/picturehouse_uk)
[![Inline docs](http://inch-ci.org/github/andycroll/picturehouse_uk.png)](http://inch-ci.org/github/andycroll/picturehouse_uk)

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
#=> [
      <PicturehouseUK::Cinema brand="Picturehouse" name="Duke's at Komedia" slug="dukes-at-komedia" chain_id="Dukes_At_Komedia" url="...">,
      <PicturehouseUK::Cinema brand="Picturehouse" name="Duke of York's" slug="duke-of-yorks" chain_id="Duke_Of_Yorks" url="...">,
      ...
    ]

PicturehouseUK::Cinema.find('Duke_Of_Yorks')
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

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
