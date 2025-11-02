require_relative '../../../test_helper'

class PicturehouseUkInternalWebsiteTest < Minitest::Test
  def setup
    WebMock.disable_net_connect!
  end

  def teardown
    WebMock.allow_net_connect!
  end

  def test_cinema_returns_string
    stub_get('cinema/duke-of-york-s-picturehouse', duke_of_yorks_html)
    result = PicturehouseUk::Internal::Website.new.cinema('duke-of-york-s-picturehouse')
    assert_equal String, result.class
  end

  def test_home_returns_string
    stub_get('', home_html)
    result = PicturehouseUk::Internal::Website.new.home
    assert_equal String, result.class
  end

  def test_information_returns_string
    stub_get(
      'cinema/duke-of-york-s-picturehouse/information',
      duke_of_yorks_information_html
    )
    result = PicturehouseUk::Internal::Website.new.information('duke-of-york-s-picturehouse')
    assert_equal String, result.class
  end

  private

  def duke_of_yorks_html
    read_file('../../../../fixtures/duke-of-york-s-picturehouse/cinema.html')
  end

  def duke_of_yorks_information_html
    read_file('../../../../fixtures/duke-of-york-s-picturehouse/information.html')
  end

  def home_html
    read_file('../../../../fixtures/home.html')
  end

  def read_file(filepath)
    File.read(File.expand_path(filepath, __FILE__))
  end

  def stub_get(site_path, response_body)
    url      = "https://www.picturehouses.com/#{site_path}"
    response = { status: 200, body: response_body, headers: {} }
    stub_request(:get, url).to_return(response)
  end
end
