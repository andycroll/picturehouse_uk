require_relative '../../test_helper'

describe PicturehouseUk::Performance do
  let(:described_class) { PicturehouseUk::Performance }
  let(:website) { FakeWebsite.new }

  before { WebMock.disable_net_connect! }
  after { WebMock.allow_net_connect! }

  describe '.at(cinema_id)' do
    let(:api_client) { FakeApi.new }
    subject { described_class.at('duke-s-at-komedia') }

    it 'returns an array of screenings' do
      PicturehouseUk::Internal::Website.stub :new, website do
        PicturehouseUk::Internal::Api.stub :new, api_client do
          _(subject).must_be_instance_of(Array)
          subject.each do |screening|
            _(screening).must_be_instance_of(PicturehouseUk::Performance)
          end
        end
      end
    end

    it 'returns correct number of screenings' do
      PicturehouseUk::Internal::Website.stub :new, website do
        PicturehouseUk::Internal::Api.stub :new, api_client do
          _(subject.count).must_equal 8
        end
      end
    end

    it 'has valid screenings' do
      PicturehouseUk::Internal::Website.stub :new, website do
        PicturehouseUk::Internal::Api.stub :new, api_client do
          subject.map(&:starting_at).each do |time|
            _(time).wont_equal Time.utc(1970, 1, 1, 0, 0)
          end
        end
      end
    end

    it 'includes different variants' do
      PicturehouseUk::Internal::Website.stub :new, website do
        PicturehouseUk::Internal::Api.stub :new, api_client do
          variants = subject.flat_map(&:variant).uniq
          _(variants).must_include 'arts'
          _(variants).must_include 'kids'
          _(variants).must_include 'senior'
        end
      end
    end

    it 'correctly identifies 3D films' do
      PicturehouseUk::Internal::Website.stub :new, website do
        PicturehouseUk::Internal::Api.stub :new, api_client do
          three_d_screenings = subject.select { |s| s.dimension == '3d' }
          _(three_d_screenings).wont_be_empty
          three_d_screenings.each do |screening|
            _(screening.film_name).must_match(/Marvels/i)
          end
        end
      end
    end

    it 'generates booking URLs' do
      PicturehouseUk::Internal::Website.stub :new, website do
        PicturehouseUk::Internal::Api.stub :new, api_client do
          subject.each do |screening|
            _(screening.booking_url).must_match(%r{\Ahttps://web\.picturehouses\.com/order/showtimes/})
          end
        end
      end
    end
  end

  describe '.new' do
    subject { described_class.new(options) }

    describe 'simple' do
      let(:options) do
        {
          film_name:   'Iron Man 3',
          cinema_id:   3,
          cinema_name: 'Cineworld Brighton',
          starting_at: Time.utc(2013, 9, 12, 11, 0)
        }
      end

      it 'sets cinema name and film name' do
        _(subject.film_name).must_equal 'Iron Man 3'
        _(subject.cinema_name).must_equal 'Cineworld Brighton'
      end

      it 'booking url, dimension & varient are set to defaults' do
        _(subject.booking_url).must_be_nil
        _(subject.dimension).must_equal '2d'
        _(subject.variant).must_equal []
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
        starting_at: Time.utc(2013, 9, 12, 11, 0)
      }
    end

    subject { described_class.new(options).dimension }

    it 'returns 2d or 3d' do
      _(subject).must_be_instance_of(String)
      _(subject).must_equal '3d'
    end
  end

  describe '#starting_at' do
    subject { described_class.new(options).starting_at }

    describe 'with utc time' do
      let(:options) do
        {
          film_name:   'Iron Man 3',
          cinema_id:   3,
          cinema_name: 'Cineworld Brighton',
          starting_at: Time.utc(2013, 9, 12, 11, 0)
        }
      end

      it 'returns UTC time' do
        _(subject).must_be_instance_of Time
        _(subject).must_equal Time.utc(2013, 9, 12, 11, 0)
      end
    end

    describe 'with non-utc time' do
      let(:options) do
        {
          film_name:   'Iron Man 3',
          cinema_id:   3,
          cinema_name: 'Cineworld Brighton',
          starting_at: Time.parse('2013-09-12 11:00')
        }
      end

      it 'returns UTC time' do
        _(subject).must_be_instance_of Time
        _(subject).must_equal Time.utc(2013, 9, 12, 10, 0)
      end
    end
  end

  describe '#showing_on' do
    let(:options) do
      {
        film_name:   'Iron Man 3',
        cinema_id:   3,
        cinema_name: 'Cineworld Brighton',
        starting_at: Time.utc(2013, 9, 12, 11, 0)
      }
    end

    subject { described_class.new(options).showing_on }

    it 'returns date of showing' do
      _(subject).must_be_instance_of(Date)
      _(subject).must_equal Date.new(2013, 9, 12)
    end
  end

  describe '#variant' do
    subject { described_class.new(options).variant }

    let(:options) do
      {
        film_name:   'Iron Man 3',
        cinema_id:   3,
        cinema_name: 'Cineworld Brighton',
        starting_at: Time.utc(2013, 9, 12, 11, 0),
        variant:     ['Kids']
      }
    end

    it 'is an alphabetically ordered array of lower-cased strings' do
      _(subject).must_be_instance_of Array
      subject.each do |tag|
        _(tag).must_be_instance_of String
      end
      _(subject).must_equal %w(kids)
    end
  end
end
