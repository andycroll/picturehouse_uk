require_relative '../../../../test_helper'

class PicturehouseUkInternalParserAddressTest < Minitest::Test
  # real functionality tested via integration

  def test_address_passed_nil_returns_hash_of_nils
    parser = PicturehouseUk::Internal::Parser::Address.new(nil)
    result = parser.address
    assert_instance_of Hash, result
    assert_equal(
      {
        street_address:   nil,
        extended_address: nil,
        locality:         nil,
        region:           nil,
        postal_code:      nil,
        country_name:     "United Kingdom"
      },
      result
    )
  end

  def test_address_passed_empty_string_returns_hash_of_nils
    parser = PicturehouseUk::Internal::Parser::Address.new('')
    result = parser.address
    assert_instance_of Hash, result
    assert_equal(
      {
        street_address:   nil,
        extended_address: nil,
        locality:         nil,
        region:           nil,
        postal_code:      nil,
        country_name:     "United Kingdom"
      },
      result
    )
  end

  def test_address_passed_nonsense_returns_hash_of_nils
    parser = PicturehouseUk::Internal::Parser::Address.new('not an address')
    result = parser.address
    assert_instance_of Hash, result
    assert_equal(
      {
        street_address:   nil,
        extended_address: nil,
        locality:         nil,
        region:           nil,
        postal_code:      nil,
        country_name:     "United Kingdom"
      },
      result
    )
  end
end
