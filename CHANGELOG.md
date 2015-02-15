# Change Log
All notable changes to this project will be documented in this file.

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
