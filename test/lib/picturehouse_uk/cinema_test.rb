require_relative '../../test_helper'

class PicturehouseUkCinemaTest < Minitest::Test
  def setup
    @website = FakeWebsite.new
    WebMock.disable_net_connect!
  end

  def teardown
    WebMock.allow_net_connect!
  end

  def test_all_returns_array_of_cinemas
    PicturehouseUk::Internal::Website.stub :new, @website do
      result = PicturehouseUk::Cinema.all
      assert_instance_of Array, result
      result.each do |value|
        assert_instance_of PicturehouseUk::Cinema, value
      end
    end
  end

  def test_all_returns_correctly_sized_array
    PicturehouseUk::Internal::Website.stub :new, @website do
      result = PicturehouseUk::Cinema.all
      assert_equal 25, result.size
    end
  end

  def test_all_returns_right_cinemas
    PicturehouseUk::Internal::Website.stub :new, @website do
      result = PicturehouseUk::Cinema.all
      assert_equal 'Little Theatre Cinema', result.first.name
      assert_equal 'City Screen York', result.last.name
    end
  end

  def test_new_stores_id_name_slug_and_url
    cinema = PicturehouseUk::Cinema.new('duke-s-at-komedia')
    assert_instance_of PicturehouseUk::Cinema, cinema
  end

  def test_adr_with_no_region_returns_address_hash
    PicturehouseUk::Internal::Website.stub :new, @website do
      cinema = PicturehouseUk::Cinema.new('phoenix-picturehouse')
      result = cinema.adr
      assert_equal(
        {
          street_address:   '57 Walton Street',
          extended_address: nil,
          locality:         'Oxford',
          region:           nil,
          postal_code:      'OX2 6AE',
          country_name:     'United Kingdom'
        },
        result
      )
    end
  end

  def test_adr_with_region_returns_address_hash
    PicturehouseUk::Internal::Website.stub :new, @website do
      cinema = PicturehouseUk::Cinema.new('duke-s-at-komedia')
      result = cinema.adr
      assert_equal(
        {
          street_address:   '44–47 Gardner Street',
          extended_address: nil,
          locality:         'Brighton',
          region:           'East Sussex',
          postal_code:      'BN1 1UN',
          country_name:     'United Kingdom'
        },
        result
      )
    end
  end

  def test_address_with_no_region_returns_address_hash
    PicturehouseUk::Internal::Website.stub :new, @website do
      cinema = PicturehouseUk::Cinema.new('phoenix-picturehouse')
      result = cinema.address
      assert_equal(
        {
          street_address:   '57 Walton Street',
          extended_address: nil,
          locality:         'Oxford',
          region:           nil,
          postal_code:      'OX2 6AE',
          country_name:     'United Kingdom'
        },
        result
      )
    end
  end

  def test_brand_returns_picturehouse
    PicturehouseUk::Internal::Website.stub :new, @website do
      cinema = PicturehouseUk::Cinema.new('duke-s-at-komedia')
      assert_equal 'Picturehouse', cinema.brand
    end
  end

  def test_country_name_returns_country
    PicturehouseUk::Internal::Website.stub :new, @website do
      cinema = PicturehouseUk::Cinema.new('duke-s-at-komedia')
      assert_equal 'United Kingdom', cinema.country_name
    end
  end

  def test_extended_address_returns_second_line_of_address
    PicturehouseUk::Internal::Website.stub :new, @website do
      cinema = PicturehouseUk::Cinema.new('duke-s-at-komedia')
      assert_equal '', cinema.extended_address
    end
  end

  def test_full_name_returns_full_name_same_as_name
    PicturehouseUk::Internal::Website.stub :new, @website do
      cinema = PicturehouseUk::Cinema.new('duke-s-at-komedia')
      assert_equal "Duke's at Komedia", cinema.full_name
      assert_equal cinema.name, cinema.full_name
    end
  end

  def test_locality_returns_locality
    PicturehouseUk::Internal::Website.stub :new, @website do
      cinema = PicturehouseUk::Cinema.new('duke-s-at-komedia')
      assert_equal 'Brighton', cinema.locality
    end
  end

  def test_name_returns_full_name
    PicturehouseUk::Internal::Website.stub :new, @website do
      cinema = PicturehouseUk::Cinema.new('duke-s-at-komedia')
      assert_equal "Duke's at Komedia", cinema.name
    end
  end

  def test_postal_code_returns_postal_code
    PicturehouseUk::Internal::Website.stub :new, @website do
      cinema = PicturehouseUk::Cinema.new('duke-s-at-komedia')
      assert_equal 'BN1 1UN', cinema.postal_code
    end
  end

  def test_region_returns_region
    PicturehouseUk::Internal::Website.stub :new, @website do
      cinema = PicturehouseUk::Cinema.new('duke-s-at-komedia')
      assert_equal 'East Sussex', cinema.region
    end
  end

  def test_slug_returns_downcased
    PicturehouseUk::Internal::Website.stub :new, @website do
      cinema = PicturehouseUk::Cinema.new('duke-s-at-komedia')
      assert_equal 'dukes-at-komedia', cinema.slug
    end
  end

  def test_street_address_returns_first_line_of_address
    PicturehouseUk::Internal::Website.stub :new, @website do
      cinema = PicturehouseUk::Cinema.new('duke-s-at-komedia')
      assert_equal '44–47 Gardner Street', cinema.street_address
    end
  end
end
