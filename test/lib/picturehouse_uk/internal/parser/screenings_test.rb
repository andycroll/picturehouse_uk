require_relative '../../../../test_helper'

class PicturehouseUkInternalParserScreeningsTest < Minitest::Test
  def setup
    @api_client = FakeApi.new
    WebMock.disable_net_connect!
  end

  def teardown
    WebMock.allow_net_connect!
  end

  def test_to_a_returns_array_of_hashes
    PicturehouseUk::Internal::Api.stub :new, @api_client do
      result = PicturehouseUk::Internal::Parser::Screenings.new('duke-s-at-komedia').to_a
      assert_instance_of Array, result
      result.each do |element|
        assert_instance_of Hash, element
      end
    end
  end

  def test_to_a_has_correct_hash_keys
    PicturehouseUk::Internal::Api.stub :new, @api_client do
      result = PicturehouseUk::Internal::Parser::Screenings.new('duke-s-at-komedia').to_a
      result.each do |element|
        assert_equal [:booking_url, :dimension, :film_name, :starting_at, :variant].sort, element.keys.sort
      end
    end
  end

  def test_to_a_has_valid_film_names
    PicturehouseUk::Internal::Api.stub :new, @api_client do
      result = PicturehouseUk::Internal::Parser::Screenings.new('duke-s-at-komedia').to_a
      film_names = result.map { |s| s[:film_name] }.uniq
      assert_includes film_names, 'The Holdovers'
      assert_includes film_names, 'The Marvels'
    end
  end

  def test_to_a_correctly_identifies_dimensions
    PicturehouseUk::Internal::Api.stub :new, @api_client do
      result = PicturehouseUk::Internal::Parser::Screenings.new('duke-s-at-komedia').to_a
      result.each do |element|
        assert_match(/\A[23]d\z/, element[:dimension])
      end
    end
  end

  def test_to_a_generates_booking_urls_with_correct_format
    PicturehouseUk::Internal::Api.stub :new, @api_client do
      result = PicturehouseUk::Internal::Parser::Screenings.new('duke-s-at-komedia').to_a
      result.each do |element|
        assert_match(%r{\Ahttps://web\.picturehouses\.com/order/showtimes/}, element[:booking_url])
        assert_match(%r{/duke-s-at-komedia-\d+/seats\z}, element[:booking_url])
      end
    end
  end

  def test_to_a_parses_starting_at_as_time_objects
    PicturehouseUk::Internal::Api.stub :new, @api_client do
      result = PicturehouseUk::Internal::Parser::Screenings.new('duke-s-at-komedia').to_a
      result.each do |element|
        assert_kind_of Time, element[:starting_at]
        refute_equal Time.utc(1970, 1, 1, 0, 0), element[:starting_at]
      end
    end
  end

  def test_to_a_extracts_variant_arrays
    PicturehouseUk::Internal::Api.stub :new, @api_client do
      result = PicturehouseUk::Internal::Parser::Screenings.new('duke-s-at-komedia').to_a
      variants = result.flat_map { |e| e[:variant] }.uniq
      assert_includes variants, 'kids'
      assert_includes variants, 'senior'
      assert_includes variants, 'arts'
    end
  end

  def test_to_a_identifies_3d_films_from_title
    PicturehouseUk::Internal::Api.stub :new, @api_client do
      result = PicturehouseUk::Internal::Parser::Screenings.new('duke-s-at-komedia').to_a
      three_d_films = result.select { |s| s[:dimension] == '3d' }
      refute_empty three_d_films
      three_d_films.each do |screening|
        assert_match(/Marvels/i, screening[:film_name])
      end
    end
  end

  def test_to_a_skips_sold_out_screenings
    PicturehouseUk::Internal::Api.stub :new, @api_client do
      result = PicturehouseUk::Internal::Parser::Screenings.new('duke-s-at-komedia').to_a
      # Our fixture has 9 total screenings but none with SoldoutStatus == 2
      assert_equal 8, result.count
    end
  end

  def test_to_a_returns_empty_array_for_error_response
    empty_client = Class.new do
      def get_movies(_cinema_id, _date = 'show_all_dates')
        { 'response' => 'error', 'movies' => [] }
      end
    end.new

    PicturehouseUk::Internal::Api.stub :new, empty_client do
      result = PicturehouseUk::Internal::Parser::Screenings.new('nonexistent').to_a
      assert_equal [], result
    end
  end

  def test_to_a_returns_empty_array_when_movies_key_missing
    missing_movies_client = Class.new do
      def get_movies(_cinema_id, _date = 'show_all_dates')
        { 'response' => 'success' }
      end
    end.new

    PicturehouseUk::Internal::Api.stub :new, missing_movies_client do
      result = PicturehouseUk::Internal::Parser::Screenings.new('test').to_a
      assert_equal [], result
    end
  end
end
