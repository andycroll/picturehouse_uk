require_relative '../../../../test_helper'

describe PicturehouseUk::Internal::Parser::Screenings do
  let(:described_class) { PicturehouseUk::Internal::Parser::Screenings }
  let(:api_client) { FakeApi.new }

  before { WebMock.disable_net_connect! }
  after { WebMock.allow_net_connect! }

  describe '#to_a' do
    subject { described_class.new('duke-s-at-komedia').to_a }

    it 'returns an array of hashes' do
      PicturehouseUk::Internal::Api.stub :new, api_client do
        _(subject).must_be_instance_of(Array)
        subject.each do |element|
          _(element).must_be_instance_of(Hash)
        end
      end
    end

    it 'has correct hash keys' do
      PicturehouseUk::Internal::Api.stub :new, api_client do
        subject.each do |element|
          _(element.keys.sort).must_equal([:booking_url, :dimension, :film_name, :starting_at, :variant].sort)
        end
      end
    end

    it 'has valid film names' do
      PicturehouseUk::Internal::Api.stub :new, api_client do
        film_names = subject.map { |s| s[:film_name] }.uniq
        _(film_names).must_include 'The Holdovers'
        _(film_names).must_include 'The Marvels'
      end
    end

    it 'correctly identifies dimensions' do
      PicturehouseUk::Internal::Api.stub :new, api_client do
        subject.each do |element|
          _(element[:dimension]).must_match(/\A[23]d\z/)
        end
      end
    end

    it 'generates booking URLs with correct format' do
      PicturehouseUk::Internal::Api.stub :new, api_client do
        subject.each do |element|
          _(element[:booking_url]).must_match(%r{\Ahttps://web\.picturehouses\.com/order/showtimes/})
          _(element[:booking_url]).must_match(%r{/duke-s-at-komedia-\d+/seats\z})
        end
      end
    end

    it 'parses starting_at as Time objects' do
      PicturehouseUk::Internal::Api.stub :new, api_client do
        subject.each do |element|
          _(element[:starting_at]).must_be_kind_of(Time)
          _(element[:starting_at]).wont_equal Time.utc(1970, 1, 1, 0, 0)
        end
      end
    end

    it 'extracts variant arrays' do
      PicturehouseUk::Internal::Api.stub :new, api_client do
        variants = subject.flat_map { |e| e[:variant] }.uniq
        _(variants).must_include('kids')
        _(variants).must_include('senior')
        _(variants).must_include('arts')
      end
    end

    it 'identifies 3D films from title' do
      PicturehouseUk::Internal::Api.stub :new, api_client do
        three_d_films = subject.select { |s| s[:dimension] == '3d' }
        _(three_d_films).wont_be_empty
        three_d_films.each do |screening|
          _(screening[:film_name]).must_match(/Marvels/i)
        end
      end
    end

    it 'skips sold out screenings' do
      PicturehouseUk::Internal::Api.stub :new, api_client do
        # Our fixture has 9 total screenings but none with SoldoutStatus == 2
        _(subject.count).must_equal 8
      end
    end
  end

  describe 'with empty response' do
    let(:empty_client) do
      Class.new do
        def get_movies(_cinema_id, _date = 'show_all_dates')
          { 'response' => 'error', 'movies' => [] }
        end
      end.new
    end

    it 'returns empty array for error response' do
      PicturehouseUk::Internal::Api.stub :new, empty_client do
        result = described_class.new('nonexistent').to_a
        _(result).must_equal []
      end
    end
  end

  describe 'with missing movies key' do
    let(:missing_movies_client) do
      Class.new do
        def get_movies(_cinema_id, _date = 'show_all_dates')
          { 'response' => 'success' }
        end
      end.new
    end

    it 'returns empty array when movies key missing' do
      PicturehouseUk::Internal::Api.stub :new, missing_movies_client do
        result = described_class.new('test').to_a
        _(result).must_equal []
      end
    end
  end
end
