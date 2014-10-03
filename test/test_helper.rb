require 'minitest/autorun'
require 'minitest/reporters'
reporter_options = { color: true, slow_count: 5 }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

require 'webmock/minitest'

require File.expand_path('../../lib/picturehouse_uk.rb', __FILE__)
