require_relative '../../test_helper'

class PicturehouseUk::CinemaTest < Minitest::Test
  def setup
    @api_response = FakeApiResponse.new
  end

  def test_new_zero_pads_id
    assert_equal '019', PicturehouseUk::Cinema.new(19).id
    assert_equal '019', PicturehouseUk::Cinema.new('019').id
  end

  def test_all_returns_cinemas
    with_fake_api do
      cinemas = PicturehouseUk::Cinema.all

      assert(cinemas.all? { |cinema| cinema.instance_of?(PicturehouseUk::Cinema) })
      assert_equal %w(002 013 019), cinemas.map(&:id)
    end
  end

  def test_adr_with_postcode_on_third_line
    expected = {
      street_address:   '3 Example Street',
      extended_address: nil,
      locality:         'Brighton',
      region:           nil,
      postal_code:      'BN1 0ZZ',
      country_name:     'United Kingdom'
    }

    with_fake_api do
      assert_equal expected, PicturehouseUk::Cinema.new(19).adr
      assert_equal expected, PicturehouseUk::Cinema.new(19).address
    end
  end

  def test_adr_with_extended_address
    with_fake_api do
      adr = PicturehouseUk::Cinema.new(13).adr

      assert_equal '2 Example Street', adr[:street_address]
      assert_equal 'Ropewalks', adr[:extended_address]
      assert_equal 'Liverpool', adr[:locality]
      assert_equal 'L1 0ZZ', adr[:postal_code]
    end
  end

  def test_brand
    assert_equal 'Picturehouse', PicturehouseUk::Cinema.new(19).brand
  end

  def test_latitude_and_longitude
    with_fake_api do
      cinema = PicturehouseUk::Cinema.new(19)

      assert_in_delta 50.8248, cinema.latitude, 0.0001
      assert_in_delta(-0.1394, cinema.longitude, 0.0001)
    end
  end

  def test_latitude_and_longitude_are_nil_without_a_location
    with_fake_api do
      assert_nil PicturehouseUk::Cinema.new(13).latitude
      assert_nil PicturehouseUk::Cinema.new(13).longitude
    end
  end

  def test_latitude_and_longitude_are_nil_at_zero_zero
    with_fake_api do
      assert_nil PicturehouseUk::Cinema.new(2).latitude
      assert_nil PicturehouseUk::Cinema.new(2).longitude
    end
  end

  def test_name_and_full_name
    with_fake_api do
      assert_equal "Duke's at Komedia", PicturehouseUk::Cinema.new(19).name
      assert_equal "Duke's at Komedia", PicturehouseUk::Cinema.new(19).full_name
    end
  end

  def test_slug
    with_fake_api do
      assert_equal 'dukes-at-komedia', PicturehouseUk::Cinema.new(19).slug
    end
  end

  def test_url
    with_fake_api do
      assert_equal 'https://www.picturehouses.com/cinema/duke-s-at-komedia',
                   PicturehouseUk::Cinema.new(19).url
    end
  end

  def test_url_uses_slug_that_differs_from_name
    with_fake_api do
      assert_equal 'https://www.picturehouses.com/cinema/picturehouse-at-fact',
                   PicturehouseUk::Cinema.new(13).url
    end
  end

  private

  def with_fake_api(&block)
    PicturehouseUk::Internal::ApiResponse.stub(:new, @api_response, &block)
  end
end
