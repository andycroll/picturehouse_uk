require_relative '../../../test_helper'

class PicturehouseUkInternalApiTest < Minitest::Test
  def setup
    @client = PicturehouseUk::Internal::Api.new
    @cinema_id = 'duke-s-at-komedia'
    WebMock.disable_net_connect!
  end

  def teardown
    WebMock.allow_net_connect!
  end

  def test_get_movies_makes_post_request_to_correct_endpoint
    stub_request(:post, 'https://www.picturehouses.com/api/get-movies-ajax')
      .with do |request|
        request.body.include?('start_date=show_all_dates') &&
          request.body.include?("cinema_id=#{@cinema_id}")
      end
      .to_return(
        status: 200,
        body: '{"response":"success","movies":[]}',
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.get_movies(@cinema_id)

    assert_instance_of Hash, result
    assert_equal 'success', result['response']
  end

  def test_get_movies_accepts_custom_date_parameter
    stub_request(:post, 'https://www.picturehouses.com/api/get-movies-ajax')
      .with do |request|
        request.body.include?('start_date=2024-11-01') &&
          request.body.include?("cinema_id=#{@cinema_id}")
      end
      .to_return(
        status: 200,
        body: '{"response":"success","movies":[]}',
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.get_movies(@cinema_id, '2024-11-01')

    assert_equal 'success', result['response']
  end

  def test_get_movies_returns_empty_hash_on_http_error
    stub_request(:post, 'https://www.picturehouses.com/api/get-movies-ajax')
      .to_return(status: 500, body: 'Internal Server Error')

    result = @client.get_movies(@cinema_id)

    assert_equal({}, result)
  end

  def test_get_movies_returns_empty_hash_on_network_error
    stub_request(:post, 'https://www.picturehouses.com/api/get-movies-ajax')
      .to_raise(StandardError.new('Network error'))

    result = @client.get_movies(@cinema_id)

    assert_equal({}, result)
  end

  def test_get_movies_parses_json_response
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

    result = @client.get_movies(@cinema_id)

    assert_instance_of Hash, result
    assert_instance_of Array, result['movies']
    assert_equal 'Test Film', result['movies'].first['Title']
  end
end
