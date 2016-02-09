require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new(color: true, slow_count: 5)
]

require 'webmock/minitest'
WebMock.allow_net_connect!

require 'webmock/minitest'

require File.expand_path('../../lib/picturehouse_uk.rb', __FILE__)

require_relative 'support/fake_website'
