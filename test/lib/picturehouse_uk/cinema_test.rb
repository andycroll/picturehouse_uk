require_relative '../../test_helper'

describe PicturehouseUk::Cinema do
  let(:described_class) { PicturehouseUk::Cinema }
  let(:website) { FakeWebsite.new }

  before { WebMock.disable_net_connect! }
  after { WebMock.allow_net_connect! }

  describe '.all' do
    subject { described_class.all }

    it 'returns an Array of CineworldUK::Cinemas' do
      PicturehouseUk::Internal::Website.stub :new, website do
        _(subject).must_be_instance_of(Array)
        subject.each do |value|
          _(value).must_be_instance_of(PicturehouseUk::Cinema)
        end
      end
    end

    it 'returns the correctly sized array' do
      PicturehouseUk::Internal::Website.stub :new, website do
        _(subject.size).must_equal 23
      end
    end

    it 'returns the right cinemas' do
      PicturehouseUk::Internal::Website.stub :new, website do
        _(subject.first.name).must_equal 'Clapham Picturehouse'
        _(subject.last.name).must_equal 'City Screen Picturehouse'
      end
    end
  end

  describe '.new(id)' do
    subject { described_class.new('Dukes_At_Komedia') }

    it 'stores id, name, slug and url' do
      _(subject).must_be_instance_of(PicturehouseUk::Cinema)
    end
  end

  describe '#adr' do
    subject { described_class.new(id).adr }

    describe 'no region' do
      let(:id) { 'Phoenix_Picturehouse' }

      it 'returns address hash' do
        PicturehouseUk::Internal::Website.stub :new, website do
          _(subject).must_equal(
            street_address:   '57 Walton Street',
            extended_address: nil,
            locality:         'Oxford',
            region:           nil,
            postal_code:      'OX2 6AE',
            country_name:     'United Kingdom'
          )
        end
      end
    end

    describe 'with region' do
      let(:id) { 'Dukes_At_Komedia' }

      it 'returns address hash' do
        PicturehouseUk::Internal::Website.stub :new, website do
          _(subject).must_equal(
            street_address:   '44–47 Gardner Street',
            extended_address: nil,
            locality:         'Brighton',
            region:           'East Sussex',
            postal_code:      'BN1 1UN',
            country_name:     'United Kingdom'
          )
        end
      end
    end
  end

  describe '#address' do
    subject { described_class.new(id).address }

    describe 'no region' do
      let(:id) { 'Phoenix_Picturehouse' }

      it 'returns address hash' do
        PicturehouseUk::Internal::Website.stub :new, website do
          _(subject).must_equal(
            street_address:   '57 Walton Street',
            extended_address: nil,
            locality:         'Oxford',
            region:           nil,
            postal_code:      'OX2 6AE',
            country_name:     'United Kingdom'
          )
        end
      end
    end
  end

  describe '#brand' do
    subject { described_class.new(id).brand }

    let(:id) { 'Dukes_At_Komedia' }

    it 'returns Picturehouse' do
      PicturehouseUk::Internal::Website.stub :new, website do
        _(subject).must_equal('Picturehouse')
      end
    end
  end

  describe '#country_name' do
    subject { described_class.new(id).country_name }

    let(:id) { 'Dukes_At_Komedia' }

    it 'returns country' do
      PicturehouseUk::Internal::Website.stub :new, website do
        _(subject).must_equal('United Kingdom')
      end
    end
  end

  describe '#extended_address' do
    subject { described_class.new(id).extended_address }

    let(:id) { 'Dukes_At_Komedia' }

    it 'returns second line of address' do
      PicturehouseUk::Internal::Website.stub :new, website do
        _(subject).must_equal('')
      end
    end
  end

  describe '#full_name' do
    subject { described_class.new(id).full_name }

    let(:id) { 'Dukes_At_Komedia' }

    it 'returns full name (same as name)' do
      PicturehouseUk::Internal::Website.stub :new, website do
        _(subject).must_equal("Duke's at Komedia")
        _(subject).must_equal(described_class.new(id).name)
      end
    end
  end

  describe '#locality' do
    subject { described_class.new(id).locality }

    let(:id) { 'Dukes_At_Komedia' }

    it 'returns second line of address' do
      PicturehouseUk::Internal::Website.stub :new, website do
        _(subject).must_equal('Brighton')
      end
    end
  end

  describe '#name' do
    subject { described_class.new(id).name }

    let(:id) { 'Dukes_At_Komedia' }

    it 'returns full name (same as name)' do
      PicturehouseUk::Internal::Website.stub :new, website do
        _(subject).must_equal("Duke's at Komedia")
      end
    end
  end

  describe '#postal_code' do
    subject { described_class.new(id).postal_code }

    let(:id) { 'Dukes_At_Komedia' }

    it 'returns second line of address' do
      PicturehouseUk::Internal::Website.stub :new, website do
        _(subject).must_equal('BN1 1UN')
      end
    end
  end

  describe '#region' do
    subject { described_class.new(id).region }

    let(:id) { 'Dukes_At_Komedia' }

    it 'returns second line of address' do
      PicturehouseUk::Internal::Website.stub :new, website do
        _(subject).must_equal('East Sussex')
      end
    end
  end

  describe '#slug' do
    subject { described_class.new(id).slug }

    let(:id) { 'Dukes_At_Komedia' }

    it 'returns downcased' do
      PicturehouseUk::Internal::Website.stub :new, website do
        _(subject).must_equal('dukes-at-komedia')
      end
    end
  end

  describe '#street_address' do
    subject { described_class.new(id).street_address }

    let(:id) { 'Dukes_At_Komedia' }

    it 'returns first line of address' do
      PicturehouseUk::Internal::Website.stub :new, website do
        _(subject).must_equal('44–47 Gardner Street')
      end
    end
  end
end
