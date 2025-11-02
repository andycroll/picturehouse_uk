require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new(color: true)
]

require File.expand_path('../../../lib/picturehouse_uk.rb', __FILE__)

class PicturehouseUkCinemaIntegrationTest < Minitest::Test
  def test_all_returns_array_of_cinemas
    result = PicturehouseUk::Cinema.all
    assert_instance_of Array, result
    result.each do |value|
      assert_instance_of PicturehouseUk::Cinema, value
    end
  end

  def test_all_returns_correctly_sized_array
    result = PicturehouseUk::Cinema.all
    assert_operator result.size, :>, 18
  end

  def test_all_returns_right_cinemas
    result = PicturehouseUk::Cinema.all
    assert_equal 'Little Theatre Cinema', result.first.name
    assert_equal 'City Screen York', result.last.name
  end
end

class PicturehouseUkPerformanceIntegrationTest < Minitest::Test
  def test_at_returns_array_of_screenings
    result = PicturehouseUk::Performance.at('Duke_Of_Yorks')
    assert_instance_of Array, result
    result.each do |performance|
      assert_instance_of PicturehouseUk::Performance, performance
    end
  end

  def test_at_returns_correct_number_of_screenings
    result = PicturehouseUk::Performance.at('Duke_Of_Yorks')
    assert_operator result.count, :>, 10
  end
end
