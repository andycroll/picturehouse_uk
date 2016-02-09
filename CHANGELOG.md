# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

The cinebase standardisation release.

### Added
- cinebase

### Removed
- Remove film concept

### Changes
- New `rake fixtures` command and implementation
- TitleSanitizer uses `cinebase`
- Cinema uses `cinebase`
- Screening becomes Performance
- Performance uses `cinebase`

## [3.0.14] - 2015-05-17

### Fixed
- Films for the following year incorrectly dated

### Changed
- Internal date calculation method changed for screenings

## [3.0.13] - 2015-05-06

### Added
- title sanitizer for Bolshoi Ballet

## [3.0.12] - 2015-05-03

### Fixed
- no duplicate 'arts' for NT Live

## [3.0.11] - 2015-05-03

### Added
- Variants work. 'arts', 'baby', 'kids', 'imax', 'senior'
- Test for screening booking urls
- Test for screenings at National Museum IMAX picturehouse

## [3.0.10] - 2015-04-12

### Changed
- Use 'NT Live'

## [3.0.9] - 2015-04-12

### Fixed
- Date parsing was busted, it's not anymore

### Changed
- Better use of Struct

## [3.0.8] - 2015-04-07

### Fixed
- Screening parsing broken by HTML change

## [3.0.7] - 2015-04-05

### Added
- Defensive behaviour for 'upcoming' cinemas with no address

## [3.0.6] - 2015-03-20

### Added
- title sanitization for R18, N/A and (Theatre)

## [3.0.5] - 2015-03-19

### Fixed
- tests for website class
- updated fixtures
- loosened parsers to allow for sold out performances

## [3.0.4] - 2015-02-17

### Fixed
- do not verify SSL

## [3.0.3] - 2015-02-17

### Fixed
- Actually require OpenSSL

## [3.0.2] - 2015-02-17

### Fixed
- SSL everywhere

## [3.0.1] - 2015-02-16

### Fixed
- bug in parsing variants

## [3.0.0] - 2015-02-15

### Fixed
- the whole damn parsing, we now look at picturehouses.com

## [2.0.5] - 2015-01-03

### Added
- parents and babies screening title
- subtitled screening

## [2.0.4] - 2015-01-01

### Added
- remove imax from film title
- remove 'Discover Tuesday' from film title
- remove 'toddler time' from film title
- remove 'singalong' from film title

## [2.0.3] - 2014-10-19

### Added
- Better Q&A/panel removal from titles
- deal with various title edge cases
- remove years from titles

## [2.0.2] - 2014-10-19

### Added
- No screenings in York for 'basement events'
- more flexible 2d removal
- better title sanitizations
- deal with ROH Encore
- better spacing on 'event' titles

## [2.0.1] - 2014-10-19

### Added
- Better parsing of ampersands in film titles
- Better parsing of autism screening film titles
- Better parsing of bad spacing in film titles
- Better parsing of Q&A events
- Better parsing of rogue screening types
- Better parsing of free screening types

## [2.0.0] - 2014-10-16

### Added
- Live testing rake task
- Ruby 2.1.3 on Travis

### Changed
- Internal structure of parsers
- Title sanitization
- Broke up monolith of Cinema class
- Fixture update
- Rubocop

### Removed
- Only the badness
