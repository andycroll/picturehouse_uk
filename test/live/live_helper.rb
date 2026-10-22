require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new(color: true)
]

require File.expand_path('../../../lib/picturehouse_uk.rb', __FILE__)
require_relative '../support/api_shapes'

PicturehouseUk.token = ENV.fetch('PICTUREHOUSE_TOKEN') { PicturehouseUk.acquire_token! }
