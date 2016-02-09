require_relative '../../../test_helper'

describe PicturehouseUk::Internal::Website do
  let(:described_class) { PicturehouseUk::Internal::Website }

  describe '#cinema(id)' do
    subject { described_class.new.cinema('Duke_Of_Yorks') }

    before { stub_get('cinema/Duke_Of_Yorks', duke_of_yorks_html) }

    it 'returns a string' do
      subject.class.must_equal String
    end
  end

  describe '#home' do
    subject { described_class.new.home }

    before { stub_get('', home_html) }

    it 'returns a string' do
      subject.class.must_equal String
    end
  end

  describe '#info(id)' do
    subject { described_class.new.info('Duke_Of_Yorks') }

    before do
      stub_get(
        'cinema/info/Duke_Of_Yorks',
        duke_of_yorks_contact_us_html
      )
    end

    it 'returns a string' do
      subject.class.must_equal String
    end
  end

  describe '#whats_on(id)' do
    subject { described_class.new.whats_on('Duke_Of_Yorks') }

    before do
      stub_get(
        'cinema/Duke_Of_Yorks/Whats_On',
        duke_of_yorks_whats_on_html
      )
    end

    it 'returns a string' do
      subject.class.must_equal String
    end
  end

  private

  def duke_of_yorks_html
    read_file('../../../../fixtures/Duke_Of_Yorks/cinema.html')
  end

  def duke_of_yorks_contact_us_html
    read_file('../../../../fixtures/Duke_Of_Yorks/info.html')
  end

  def duke_of_yorks_whats_on_html
    read_file('../../../../fixtures/Duke_Of_Yorks/whats_on.html')
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
