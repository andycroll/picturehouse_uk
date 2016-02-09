require_relative '../../../../test_helper'

describe PicturehouseUk::Internal::Parser::Address do
  let(:described_class) { PicturehouseUk::Internal::Parser::Address }

  describe '#address' do
    subject { described_class.new(html).address }

    # real functionality tested via integration

    describe 'passed nil' do
      let(:html) { nil }

      it 'returns hash of nils' do
        subject.must_be_instance_of(Hash)
        subject.must_equal(street_address:   nil,
                           extended_address: nil,
                           locality:         nil,
                           region:           nil,
                           postal_code:      nil,
                           country_name:     "United Kingdom")
      end
    end

    describe 'passed empty string' do
      let(:html) { '' }

      it 'returns hash of nils' do
        subject.must_be_instance_of(Hash)
        subject.must_equal(street_address:   nil,
                           extended_address: nil,
                           locality:         nil,
                           region:           nil,
                           postal_code:      nil,
                           country_name:     "United Kingdom")
      end
    end

    describe 'passed nonsense' do
      let(:html) { 'not an address' }

      it 'returns hash of nils' do
        subject.must_be_instance_of(Hash)
        subject.must_equal(street_address:   nil,
                           extended_address: nil,
                           locality:         "not an address",
                           region:           nil,
                           postal_code:      "not an address",
                           country_name:     "United Kingdom")
      end
    end
  end
end
