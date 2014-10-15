# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'picturehouse_uk/version'

Gem::Specification.new do |spec|
  spec.name          = 'picturehouse_uk'
  spec.version       = PicturehouseUk::VERSION
  spec.authors       = ['Andy Croll']
  spec.email         = ['andy@goodscary.com']
  spec.description   = 'An API to pull movie information from the picturehouse.co.uk website'
  spec.summary       = "It's a scraper, but a nice one"
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'webmock'

  spec.add_runtime_dependency 'nokogiri'
  spec.add_runtime_dependency 'tzinfo'
  spec.add_runtime_dependency 'tzinfo-data'
end
