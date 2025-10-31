require_relative '../../../test_helper'

describe PicturehouseUk::Internal::Api do
  let(:described_class) { PicturehouseUk::Internal::Api }

  before { WebMock.disable_net_connect! }
  after { WebMock.allow_net_connect! }

  describe '#get_movies' do
    let(:client) { described_class.new }
    let(:cinema_id) { 'duke-s-at-komedia' }

    it 'makes POST request to correct endpoint' do
      stub_request(:post, 'https://www.picturehouses.com/api/get-movies-ajax')
        .with do |request|
          request.body.include?('start_date=show_all_dates') &&
            request.body.include?("cinema_id=#{cinema_id}")
        end
        .to_return(
          status: 200,
          body: '{"response":"success","movies":[]}',
          headers: { 'Content-Type' => 'application/json' }
        )

      result = client.get_movies(cinema_id)

      _(result).must_be_instance_of(Hash)
      _(result['response']).must_equal 'success'
    end

    it 'accepts custom date parameter' do
      stub_request(:post, 'https://www.picturehouses.com/api/get-movies-ajax')
        .with do |request|
          request.body.include?('start_date=2024-11-01') &&
            request.body.include?("cinema_id=#{cinema_id}")
        end
        .to_return(
          status: 200,
          body: '{"response":"success","movies":[]}',
          headers: { 'Content-Type' => 'application/json' }
        )

      result = client.get_movies(cinema_id, '2024-11-01')

      _(result['response']).must_equal 'success'
    end

    it 'returns empty hash on HTTP error' do
      stub_request(:post, 'https://www.picturehouses.com/api/get-movies-ajax')
        .to_return(status: 500, body: 'Internal Server Error')

      result = client.get_movies(cinema_id)

      _(result).must_equal({})
    end

    it 'returns empty hash on network error' do
      stub_request(:post, 'https://www.picturehouses.com/api/get-movies-ajax')
        .to_raise(StandardError.new('Network error'))

      result = client.get_movies(cinema_id)

      _(result).must_equal({})
    end

    it 'parses JSON response' do
      response_body = {
        'response' => 'success',
        'movies' => [
          {
            'Title' => 'Test Film',
            'ScheduledFilmId' => '12345',
            'movie_times' => []
          }
        ]
      }.to_json

      stub_request(:post, 'https://www.picturehouses.com/api/get-movies-ajax')
        .to_return(
          status: 200,
          body: response_body,
          headers: { 'Content-Type' => 'application/json' }
        )

      result = client.get_movies(cinema_id)

      _(result).must_be_instance_of(Hash)
      _(result['movies']).must_be_instance_of(Array)
      _(result['movies'].first['Title']).must_equal 'Test Film'
    end
  end
end
