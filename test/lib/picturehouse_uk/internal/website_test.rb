require_relative '../../../test_helper'

describe PicturehouseUk::Internal::Website do
  let(:described_class) { PicturehouseUk::Internal::Website }

  before { WebMock.disable_net_connect! }
  after { WebMock.allow_net_connect! }

  describe '#cinema(id)' do
    subject { described_class.new.cinema('duke-of-york-s-picturehouse') }

    before { stub_get('cinema/duke-of-york-s-picturehouse', duke_of_yorks_html) }

    it 'returns a string' do
      _(subject.class).must_equal String
    end
  end

  describe '#home' do
    subject { described_class.new.home }

    before { stub_get('', home_html) }

    it 'returns a string' do
      _(subject.class).must_equal String
    end
  end

  describe '#information(id)' do
    subject { described_class.new.information('duke-of-york-s-picturehouse') }

    before do
      stub_get(
        'cinema/duke-of-york-s-picturehouse/information',
        duke_of_yorks_information_html
      )
    end

    it 'returns a string' do
      _(subject.class).must_equal String
    end
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
