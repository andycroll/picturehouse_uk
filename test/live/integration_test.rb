require_relative 'live_helper'

class LiveCinemaTest < Minitest::Test
  def test_all_returns_cinemas
    cinemas = PicturehouseUk::Cinema.all

    assert(cinemas.all? { |cinema| cinema.instance_of?(PicturehouseUk::Cinema) })
    assert_operator cinemas.size, :>, 18
    assert_equal "Duke's at Komedia", cinemas.detect { |cinema| cinema.id == '019' }.name
  end

  def test_every_cinema_has_a_postcode
    PicturehouseUk::Cinema.all.each do |cinema|
      refute_empty cinema.postal_code, "#{cinema.id} #{cinema.name}"
    end
  end

  def test_cinemas_have_uk_coordinates
    located = PicturehouseUk::Cinema.all.select(&:latitude)

    refute_empty located
    located.each do |cinema|
      assert_includes 49.0..61.0, cinema.latitude, "#{cinema.id} #{cinema.name}"
      assert_includes(-9.0..2.0, cinema.longitude, "#{cinema.id} #{cinema.name}")
    end
  end
end

class LivePerformanceTest < Minitest::Test
  def test_at_returns_performances
    tomorrow = Date.today + 1
    performances = PicturehouseUk::Performance.at(19, from: tomorrow, to: tomorrow)

    assert(performances.all? { |p| p.instance_of?(PicturehouseUk::Performance) })
    assert_operator performances.count, :>, 5
  end
end
