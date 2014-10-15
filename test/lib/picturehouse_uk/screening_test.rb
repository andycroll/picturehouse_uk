require_relative '../../test_helper'

describe PicturehouseUk::Screening do
  let(:website) { MockWebsite.new }

  before { WebMock.disable_net_connect! }

  describe '.at(cinema_id)' do
    subject { PicturehouseUk::Screening.at('Duke_Of_Yorks') }

    it 'returns an array of screenings' do
      PicturehouseUk::Internal::Website.stub :new, website do
        subject.must_be_instance_of(Array)
        subject.each do |screening|
          screening.must_be_instance_of(PicturehouseUk::Screening)
        end
      end
    end

    it 'returns correct number of screenings' do
      PicturehouseUk::Internal::Website.stub :new, website do
        subject.count.must_equal 29
      end
    end
  end

  describe '.new' do
    subject { PicturehouseUk::Screening.new(options) }

    describe 'simple' do
      let(:options) do
        {
          film_name:   'Iron Man 3',
          cinema_id:   3,
          cinema_name: 'Cineworld Brighton',
          time:        Time.utc(2013, 9, 12, 11, 0)
        }
      end

      it 'sets cinema name and film name' do
        subject.film_name.must_equal 'Iron Man 3'
        subject.cinema_name.must_equal 'Cineworld Brighton'
      end

      it 'booking url, dimension & varient are set to defaults' do
        subject.booking_url.must_equal nil
        subject.dimension.must_equal '2d'
        subject.variant.must_equal []
      end
    end
  end

  describe '#dimension' do
    let(:options) do
      {
        film_name:   'Iron Man 3',
        dimension:   '3d',
        cinema_id:   3,
        cinema_name: 'Cineworld Brighton',
        time:        Time.utc(2013, 9, 12, 11, 0)
      }
    end

    subject { PicturehouseUk::Screening.new(options).dimension }

    it 'returns 2d or 3d' do
      subject.must_be_instance_of(String)
      subject.must_equal '3d'
    end
  end

  describe '#showing_at' do
    subject { PicturehouseUk::Screening.new(options).showing_at }

    describe 'with utc time' do
      let(:options) do
        {
          film_name:   'Iron Man 3',
          cinema_id:   3,
          cinema_name: 'Cineworld Brighton',
          time:        Time.utc(2013, 9, 12, 11, 0)
        }
      end

      it 'returns UTC time' do
        subject.must_be_instance_of Time
        subject.must_equal Time.utc(2013, 9, 12, 11, 0)
      end
    end

    describe 'with non-utc time' do
      let(:options) do
        {
          film_name:   'Iron Man 3',
          cinema_id:   3,
          cinema_name: 'Cineworld Brighton',
          time:        Time.parse('2013-09-12 11:00')
        }
      end

      it 'returns UTC time' do
        subject.must_be_instance_of Time
        subject.must_equal Time.utc(2013, 9, 12, 10, 0)
      end
    end
  end

  describe '#showing_on' do
    let(:options) do
      {
        film_name:   'Iron Man 3',
        cinema_id:   3,
        cinema_name: 'Cineworld Brighton',
        time:        Time.utc(2013, 9, 12, 11, 0)
      }
    end

    subject { PicturehouseUk::Screening.new(options).showing_on }

    it 'returns date of showing' do
      subject.must_be_instance_of(Date)
      subject.must_equal Date.new(2013, 9, 12)
    end
  end

  describe '#variant' do
    subject { PicturehouseUk::Screening.new(options).variant }

    let(:options) do
      {
        film_name:   'Iron Man 3',
        cinema_id:   3,
        cinema_name: 'Cineworld Brighton',
        time:        Time.utc(2013, 9, 12, 11, 0),
        variant:     ['Kids']
      }
    end

    it 'is an alphabetically ordered array of lower-cased strings' do
      subject.must_be_instance_of Array
      subject.each do |tag|
        tag.must_be_instance_of String
      end
      subject.must_equal %w(kids)
    end
  end

  private

  class MockWebsite
    def home
      read_file('../../../fixtures/home.html')
    end

    def cinema(filename)
      read_file("../../../fixtures/cinema/#{filename}.html")
    end

    def contact_us(filename)
      read_file("../../../fixtures/contact_us/#{filename}.html")
    end

    private

    def read_file(filepath)
      File.read(File.expand_path(filepath, __FILE__))
    end
  end
end
