require_relative '../../test_helper'

describe PicturehouseUk::Cinema do

  before { WebMock.disable_net_connect! }

  describe '.all' do
    subject { PicturehouseUk::Cinema.all }

    before do
      homepage_body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'picturehouses-homepage.html') )
      stub_request(:get, 'http://www.picturehouses.co.uk/').to_return( status: 200, body: homepage_body, headers: {} )
    end

    it 'returns an Array of PicturehouseUk::Cinemas' do
      subject.must_be_instance_of(Array)
      subject.each do |value|
        value.must_be_instance_of(PicturehouseUk::Cinema)
      end
    end

    it 'returns the correctly sized array' do
      subject.size.must_equal 21
    end

    it 'returns the right cinemas' do
      subject.first.name.must_equal 'Clapham Picturehouse'
      subject.last.name.must_equal 'City Screen Picturehouse'
    end
  end

  describe '.new id, name, url' do
    it 'stores id, name, slug and url' do
      cinema = PicturehouseUk::Cinema.new 'Dukes_At_Komedia', "Duke's At Komedia", '/cinemas/Dukes_At_Komedia/'
      cinema.id.must_equal 'Dukes_At_Komedia'
      cinema.brand.must_equal 'Picturehouse'
      cinema.name.must_equal "Duke's At Komedia"
      cinema.slug.must_equal 'dukes-at-komedia'
      cinema.url.must_equal 'http://www.picturehouses.co.uk/cinemas/Dukes_At_Komedia/'
    end
  end
end
