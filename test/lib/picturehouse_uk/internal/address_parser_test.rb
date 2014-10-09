require_relative '../../../test_helper'

describe PicturehouseUk::Internal::AddressParser do
  let(:described_class) { PicturehouseUk::Internal::AddressParser }

  describe '#address' do
    subject { described_class.new(html).address }

    describe 'standard address' do # brighton
      let(:html) { address_html('duke-of-yorks') }

      it 'returns a hash' do
        subject.class.must_equal Hash
      end

      it 'contains the correct keys' do
        subject.must_equal(
          street_address:   'Preston Circus',
          extended_address: nil,
          locality:         'Brighton',
          postal_code:      'BN1 4NA',
          country:          'United Kingdom'
        )
      end
    end

    describe 'freak address: hackney' do
      let(:html) { address_html('hackney-picturehouse') }

      it 'returns a hash' do
        subject.class.must_equal Hash
      end

      it 'contains the correct keys' do
        subject.must_equal(
          street_address:   '270 Mare Street',
          extended_address: nil,
          locality:         'London',
          postal_code:      'E8 1HE',
          country:          'United Kingdom'
        )
      end
    end
  end

  private

  def read_file(filepath)
    File.read(File.expand_path(filepath, __FILE__))
  end

  def address_html(cinema)
    read_file("../../../../fixtures/address-fragments/#{cinema}.html")
  end
end
