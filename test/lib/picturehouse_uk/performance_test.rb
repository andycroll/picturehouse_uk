require_relative '../../test_helper'

class PicturehouseUkPerformanceTest < Minitest::Test
  def setup
    @website = FakeWebsite.new
    @api_client = FakeApi.new
    WebMock.disable_net_connect!
  end

  def teardown
    WebMock.allow_net_connect!
  end

  def test_at_returns_array_of_screenings
    PicturehouseUk::Internal::Website.stub :new, @website do
      PicturehouseUk::Internal::Api.stub :new, @api_client do
        result = PicturehouseUk::Performance.at('duke-s-at-komedia')
        assert_instance_of Array, result
        result.each do |screening|
          assert_instance_of PicturehouseUk::Performance, screening
        end
      end
    end
  end

  def test_at_returns_correct_number_of_screenings
    PicturehouseUk::Internal::Website.stub :new, @website do
      PicturehouseUk::Internal::Api.stub :new, @api_client do
        result = PicturehouseUk::Performance.at('duke-s-at-komedia')
        assert_equal 8, result.count
      end
    end
  end

  def test_at_has_valid_screenings
    PicturehouseUk::Internal::Website.stub :new, @website do
      PicturehouseUk::Internal::Api.stub :new, @api_client do
        result = PicturehouseUk::Performance.at('duke-s-at-komedia')
        result.map(&:starting_at).each do |time|
          refute_equal Time.utc(1970, 1, 1, 0, 0), time
        end
      end
    end
  end

  def test_at_includes_different_variants
    PicturehouseUk::Internal::Website.stub :new, @website do
      PicturehouseUk::Internal::Api.stub :new, @api_client do
        result = PicturehouseUk::Performance.at('duke-s-at-komedia')
        variants = result.flat_map(&:variant).uniq
        assert_includes variants, 'arts'
        assert_includes variants, 'kids'
        assert_includes variants, 'senior'
      end
    end
  end

  def test_at_correctly_identifies_3d_films
    PicturehouseUk::Internal::Website.stub :new, @website do
      PicturehouseUk::Internal::Api.stub :new, @api_client do
        result = PicturehouseUk::Performance.at('duke-s-at-komedia')
        three_d_screenings = result.select { |s| s.dimension == '3d' }
        refute_empty three_d_screenings
        three_d_screenings.each do |screening|
          assert_match(/Marvels/i, screening.film_name)
        end
      end
    end
  end

  def test_at_generates_booking_urls
    PicturehouseUk::Internal::Website.stub :new, @website do
      PicturehouseUk::Internal::Api.stub :new, @api_client do
        result = PicturehouseUk::Performance.at('duke-s-at-komedia')
        result.each do |screening|
          assert_match(%r{\Ahttps://web\.picturehouses\.com/order/showtimes/}, screening.booking_url)
        end
      end
    end
  end

  def test_new_simple_sets_cinema_name_and_film_name
    options = {
      film_name:   'Iron Man 3',
      cinema_id:   3,
      cinema_name: 'Cineworld Brighton',
      starting_at: Time.utc(2013, 9, 12, 11, 0)
    }
    performance = PicturehouseUk::Performance.new(options)
    assert_equal 'Iron Man 3', performance.film_name
    assert_equal 'Cineworld Brighton', performance.cinema_name
  end

  def test_new_simple_sets_defaults_for_booking_url_dimension_and_variant
    options = {
      film_name:   'Iron Man 3',
      cinema_id:   3,
      cinema_name: 'Cineworld Brighton',
      starting_at: Time.utc(2013, 9, 12, 11, 0)
    }
    performance = PicturehouseUk::Performance.new(options)
    assert_nil performance.booking_url
    assert_equal '2d', performance.dimension
    assert_equal [], performance.variant
  end

  def test_dimension_returns_2d_or_3d
    options = {
      film_name:   'Iron Man 3',
      dimension:   '3d',
      cinema_id:   3,
      cinema_name: 'Cineworld Brighton',
      starting_at: Time.utc(2013, 9, 12, 11, 0)
    }
    performance = PicturehouseUk::Performance.new(options)
    assert_instance_of String, performance.dimension
    assert_equal '3d', performance.dimension
  end

  def test_starting_at_with_utc_time_returns_utc_time
    options = {
      film_name:   'Iron Man 3',
      cinema_id:   3,
      cinema_name: 'Cineworld Brighton',
      starting_at: Time.utc(2013, 9, 12, 11, 0)
    }
    performance = PicturehouseUk::Performance.new(options)
    assert_instance_of Time, performance.starting_at
    assert_equal Time.utc(2013, 9, 12, 11, 0), performance.starting_at
  end

  def test_starting_at_with_non_utc_time_returns_utc_time
    options = {
      film_name:   'Iron Man 3',
      cinema_id:   3,
      cinema_name: 'Cineworld Brighton',
      starting_at: Time.parse('2013-09-12 11:00')
    }
    performance = PicturehouseUk::Performance.new(options)
    assert_instance_of Time, performance.starting_at
    assert_equal Time.utc(2013, 9, 12, 10, 0), performance.starting_at
  end

  def test_showing_on_returns_date_of_showing
    options = {
      film_name:   'Iron Man 3',
      cinema_id:   3,
      cinema_name: 'Cineworld Brighton',
      starting_at: Time.utc(2013, 9, 12, 11, 0)
    }
    performance = PicturehouseUk::Performance.new(options)
    assert_instance_of Date, performance.showing_on
    assert_equal Date.new(2013, 9, 12), performance.showing_on
  end

  def test_variant_is_alphabetically_ordered_array_of_lowercased_strings
    options = {
      film_name:   'Iron Man 3',
      cinema_id:   3,
      cinema_name: 'Cineworld Brighton',
      starting_at: Time.utc(2013, 9, 12, 11, 0),
      variant:     ['Kids']
    }
    performance = PicturehouseUk::Performance.new(options)
    assert_instance_of Array, performance.variant
    performance.variant.each do |tag|
      assert_instance_of String, tag
    end
    assert_equal %w(kids), performance.variant
  end
end
