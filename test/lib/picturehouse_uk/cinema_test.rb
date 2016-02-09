require_relative '../../test_helper'

describe PicturehouseUk::Cinema do
  let(:described_class) { PicturehouseUk::Cinema }
  let(:website) { FakeWebsite.new }

  before { WebMock.disable_net_connect! }

  describe '.all' do
    subject { described_class.all }

    it 'returns an Array of CineworldUK::Cinemas' do
      PicturehouseUk::Internal::Website.stub :new, website do
        subject.must_be_instance_of(Array)
        subject.each do |value|
          value.must_be_instance_of(PicturehouseUk::Cinema)
        end
      end
    end

    it 'returns the correctly sized array' do
      PicturehouseUk::Internal::Website.stub :new, website do
        subject.size.must_equal 23
      end
    end

    it 'returns the right cinemas' do
      PicturehouseUk::Internal::Website.stub :new, website do
        subject.first.name.must_equal 'Clapham Picturehouse'
        subject.last.name.must_equal 'City Screen Picturehouse'
      end
    end
  end

  describe '.find(id)' do
    subject { described_class.find(id) }

    let(:id) { 'Duke_Of_Yorks' }

    it 'returns a cinema' do
      PicturehouseUk::Internal::Website.stub :new, website do
        subject.must_be_instance_of(PicturehouseUk::Cinema)

        subject.id.must_equal id
        subject.brand.must_equal 'Picturehouse'
        subject.name.must_equal "Duke of York's Picturehouse"
        subject.slug.must_equal 'duke-of-yorks-picturehouse'
        subject.url.must_equal "http://www.picturehouses.com/cinema/#{id}"
      end
    end
  end

  describe '.new(options)' do
    let(:options) do
      {
        id:   'Dukes_At_Komedia',
        name: "Duke's At Komedia",
        url:  '/cinema/Dukes_At_Komedia'
      }
    end

    subject { described_class.new(options) }

    it 'stores id, name, slug and url' do
      subject.id.must_equal 'Dukes_At_Komedia'
      subject.brand.must_equal 'Picturehouse'
      subject.name.must_equal "Duke's At Komedia"
      subject.slug.must_equal 'dukes-at-komedia'
      subject.url.must_equal 'http://www.picturehouses.com/cinema/Dukes_At_Komedia'
    end
  end

  describe '#adr' do
    let(:options) do
      {
        id:   'Phoenix_Picturehouse',
        name: "Pheonix Picturehouse",
        url:  '/cinema/Phoenix_Picturehouse'
      }
    end

    describe '#adr' do
      subject { described_class.new(options).adr }

      it 'returns address hash' do
        PicturehouseUk::Internal::Website.stub :new, website do
          subject.must_equal(
            street_address:   '57 Walton Street',
            extended_address: nil,
            locality:         'Oxford',
            region:           nil,
            postal_code:      'OX2 6AE',
            country:          'United Kingdom'
          )
        end
      end
    end
  end

  describe 'integration-y address tests' do
    let(:options) do
      {
        id:   'Dukes_At_Komedia',
        name: "Duke's At Komedia",
        url:  '/cinema/Dukes_At_Komedia'
      }
    end

    describe '#adr' do
      subject { described_class.new(options).adr }

      it 'returns address hash' do
        PicturehouseUk::Internal::Website.stub :new, website do
          subject.must_equal(
            street_address:   '44–47 Gardner Street',
            extended_address: nil,
            locality:         'Brighton',
            region:           'East Sussex',
            postal_code:      'BN1 1UN',
            country:          'United Kingdom'
          )
        end
      end
    end

    describe '#street_address' do
      subject { described_class.new(options).street_address }

      it 'returns first line of address' do
        PicturehouseUk::Internal::Website.stub :new, website do
          subject.must_equal('44–47 Gardner Street')
        end
      end
    end

    describe '#extended_address' do
      subject { described_class.new(options).extended_address }

      it 'returns second line of address' do
        PicturehouseUk::Internal::Website.stub :new, website do
          subject.must_equal(nil)
        end
      end
    end

    describe '#locality' do
      subject { described_class.new(options).locality }

      it 'returns second line of address' do
        PicturehouseUk::Internal::Website.stub :new, website do
          subject.must_equal('Brighton')
        end
      end
    end

    describe '#region' do
      subject { described_class.new(options).region }

      it 'returns second line of address' do
        PicturehouseUk::Internal::Website.stub :new, website do
          subject.must_equal('East Sussex')
        end
      end
    end

    describe '#postal_code' do
      subject { described_class.new(options).postal_code }

      it 'returns second line of address' do
        PicturehouseUk::Internal::Website.stub :new, website do
          subject.must_equal('BN1 1UN')
        end
      end
    end
  end

  describe '#full_name' do
    let(:options) do
      {
        id:   'Dukes_At_Komedia',
        name: "Duke's At Komedia",
        url:  '/cinema/Dukes_At_Komedia'
      }
    end

    subject { described_class.new(options).full_name }

    it 'returns the cinema name' do
      subject.must_equal "Duke's At Komedia"
    end
  end

  describe '#screenings' do
    let(:options) do
      {
        id:   'Dukes_At_Komedia',
        name: "Duke's At Komedia",
        url:  '/cinema/Dukes_At_Komedia'
      }
    end

    subject { described_class.new(options).screenings }

    it 'calls out to Screening object' do
      PicturehouseUk::Screening.stub :at, [:screening] do
        subject.must_equal([:screening])
      end
    end
  end

  private

  class FakeWebsite
    def home
      read_file('../../../fixtures/home.html')
    end

    def cinema(cinema_id)
      read_file("../../../fixtures/#{cinema_id}/cinema.html")
    end

    def info(cinema_id)
      read_file("../../../fixtures/#{cinema_id}/info.html")
    end

    private

    def read_file(filepath)
      File.read(File.expand_path(filepath, __FILE__))
    end
  end
end
