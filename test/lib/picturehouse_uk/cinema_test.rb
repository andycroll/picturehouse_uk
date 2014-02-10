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

  describe '.find(id)' do
    let(:id) { 'Dukes_At_Komedia' }

    subject { PicturehouseUk::Cinema.find(id) }

    before do
      homepage_body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'picturehouses-homepage.html') )
      stub_request(:get, 'http://www.picturehouses.co.uk/').to_return( status: 200, body: homepage_body, headers: {} )
    end

    it 'returns a cinema' do
      subject.must_be_instance_of(PicturehouseUk::Cinema)

      subject.id.must_equal 'Dukes_At_Komedia'
      subject.brand.must_equal 'Picturehouse'
      subject.name.must_equal "Duke's At Komedia"
      subject.slug.must_equal 'dukes-at-komedia'
      subject.url.must_equal 'http://www.picturehouses.co.uk/cinema/Dukes_At_Komedia/'
    end
  end

  describe '.new id, name, url' do
    it 'stores id, name, slug and url' do
      cinema = PicturehouseUk::Cinema.new 'Dukes_At_Komedia', "Duke's At Komedia", '/cinema/Dukes_At_Komedia/'
      cinema.id.must_equal 'Dukes_At_Komedia'
      cinema.brand.must_equal 'Picturehouse'
      cinema.name.must_equal "Duke's At Komedia"
      cinema.slug.must_equal 'dukes-at-komedia'
      cinema.url.must_equal 'http://www.picturehouses.co.uk/cinema/Dukes_At_Komedia/'
    end
  end

  describe '#adr' do
    subject { cinema.adr }

    describe '(abbeygate)' do
      let(:cinema) { PicturehouseUk::Cinema.new('Abbeygate_Picturehouse', 'Abbeygate Picturehouse', '/cinema/Abbeygate_Picturehouse/') }

      before do
        body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'abbeygate-contact-us.html') )
        stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Abbeygate_Picturehouse/Hires_Info/Contact_Us/').to_return( status: 200, body: body, headers: {} )
      end

      it 'returns a Hash' do
        subject.must_be_instance_of Hash
      end

      it 'returns address hash' do
        subject.must_equal({
          :street_address=>"4 Hatter Street",
          :extended_address=>nil,
          :locality=>"Bury St Edmunds",
          :postal_code=>"IP33 1NE",
          :country=>"United Kingdom"
        })
      end
    end

    describe '(hackney)' do
      let(:cinema) { PicturehouseUk::Cinema.new('Hackney_Picturehouse', 'Hackney Picturehouse', '/cinema/Hackney_Picturehouse/') }

      before do
        body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'hackney-contact-us.html') )
        stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Hackney_Picturehouse/Hires_Info/Contact_Us/').to_return( status: 200, body: body, headers: {} )
      end

      it 'returns address hash' do
        subject.must_equal({
          :street_address=>"270 Mare Street",
          :extended_address=>nil,
          :locality=>"London",
          :postal_code=>"E8 1HE",
          :country=>"United Kingdom"
        })
      end
    end

    describe '(komedia)' do
      let(:cinema) { PicturehouseUk::Cinema.new('Dukes_At_Komedia', "Duke's At Komedia", '/cinema/Dukes_At_Komedia/') }

      before do
        body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'dukes-at-komedia-contact-us.html') )
        stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Dukes_At_Komedia/Hires_Info/Contact_Us/').to_return( status: 200, body: body, headers: {} )
      end

      it 'returns address hash' do
        subject.must_equal({
          :street_address=>"44-47 Gardner Street",
          :extended_address=>"North Laine",
          :locality=>"Brighton",
          :postal_code=>"BN1 1UN",
          :country=>"United Kingdom"
        })
      end
    end
  end

  describe '#extended_address' do
    subject { cinema.extended_address }

    describe '(abbeygate)' do
      let(:cinema) { PicturehouseUk::Cinema.new('Abbeygate_Picturehouse', 'Abbeygate Picturehouse', '/cinema/Abbeygate_Picturehouse/') }

      before do
        body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'abbeygate-contact-us.html') )
        stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Abbeygate_Picturehouse/Hires_Info/Contact_Us/').to_return( status: 200, body: body, headers: {} )
      end

      it 'returns nil when no second line' do
        subject.must_be_nil
      end
    end

    describe '(hackney)' do
      let(:cinema) { PicturehouseUk::Cinema.new('Hackney_Picturehouse', 'Hackney Picturehouse', '/cinema/Hackney_Picturehouse/') }

      before do
        body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'hackney-contact-us.html') )
        stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Hackney_Picturehouse/Hires_Info/Contact_Us/').to_return( status: 200, body: body, headers: {} )
      end

      it 'returns nil when no second line' do
        subject.must_be_nil
      end
    end

    describe '(komedia)' do
      let(:cinema) { PicturehouseUk::Cinema.new('Dukes_At_Komedia', "Duke's At Komedia", '/cinema/Dukes_At_Komedia/') }

      before do
        body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'dukes-at-komedia-contact-us.html') )
        stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Dukes_At_Komedia/Hires_Info/Contact_Us/').to_return( status: 200, body: body, headers: {} )
      end

      it 'returns the second line of the address' do
        subject.must_equal 'North Laine'
      end
    end
  end

  describe '#films' do
    let(:cinema) { PicturehouseUk::Cinema.new 'Dukes_At_Komedia', "Duke's At Komedia", '/cinema/Dukes_At_Komedia/' }
    subject { cinema.films }

    before do
      dukes_cinema_body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'dukes-at-komedia-cinema.html') )
      stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Dukes_At_Komedia/').to_return( status: 200, body: dukes_cinema_body, headers: {} )
    end

    it 'returns an array of films' do
      subject.must_be_instance_of(Array)
      subject.each do |item|
        item.must_be_instance_of(PicturehouseUk::Film)
      end
    end

    it 'returns correct number of films' do
      subject.count.must_equal 37
    end

    it 'returns uniquely named films' do
      first_name = subject.first.name
      first = subject.first

      subject[1..-1].each { |item| item.name.wont_equal first_name }
      subject[1..-1].each { |item| item.wont_equal first }
    end

    it 'returns film objects with correct names' do
      subject.first.name.must_equal 'Blue Jasmine'
      subject.last.name.must_equal 'Royal Opera House: Manon Lescaut'
    end
  end

  describe '#full_name' do
    subject { cinema.full_name }

    describe '(abbeygate)' do
      let(:cinema) { PicturehouseUk::Cinema.new('Abbeygate_Picturehouse', 'Abbeygate Picturehouse', '/cinema/Abbeygate_Picturehouse/') }

      before do
        body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'abbeygate-contact-us.html') )
        stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Abbeygate_Picturehouse/Hires_Info/Contact_Us/').to_return( status: 200, body: body, headers: {} )
      end

      it 'returns the cinema name' do
        subject.must_equal 'Abbeygate Picturehouse'
      end
    end

    describe '(komedia)' do
      let(:cinema) { PicturehouseUk::Cinema.new('Dukes_At_Komedia', "Duke's At Komedia", '/cinema/Dukes_At_Komedia/') }

      before do
        body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'dukes-at-komedia-contact-us.html') )
        stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Dukes_At_Komedia/Hires_Info/Contact_Us/').to_return( status: 200, body: body, headers: {} )
      end

      it 'returns the cinema name' do
        subject.must_equal "Duke's At Komedia"
      end
    end
  end

  describe '#locality' do
    subject { cinema.locality }

    describe '(abbeygate)' do
      let(:cinema) { PicturehouseUk::Cinema.new('Abbeygate_Picturehouse', 'Abbeygate Picturehouse', '/cinema/Abbeygate_Picturehouse/') }

      before do
        body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'abbeygate-contact-us.html') )
        stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Abbeygate_Picturehouse/Hires_Info/Contact_Us/').to_return( status: 200, body: body, headers: {} )
      end

      it 'returns the town' do
        subject.must_equal 'Bury St Edmunds'
      end
    end

    describe '(hackney)' do
      let(:cinema) { PicturehouseUk::Cinema.new('Hackney_Picturehouse', 'Hackney Picturehouse', '/cinema/Hackney_Picturehouse/') }

      before do
        body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'hackney-contact-us.html') )
        stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Hackney_Picturehouse/Hires_Info/Contact_Us/').to_return( status: 200, body: body, headers: {} )
      end

      it 'returns the town' do
        subject.must_equal 'London'
      end
    end

    describe '(komedia)' do
      let(:cinema) { PicturehouseUk::Cinema.new('Dukes_At_Komedia', "Duke's At Komedia", '/cinema/Dukes_At_Komedia/') }

      before do
        body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'dukes-at-komedia-contact-us.html') )
        stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Dukes_At_Komedia/Hires_Info/Contact_Us/').to_return( status: 200, body: body, headers: {} )
      end

      it 'returns the town' do
        subject.must_equal 'Brighton'
      end
    end
  end

  describe '#postal_code' do
    subject { cinema.postal_code }

    describe '(abbeygate)' do
      let(:cinema) { PicturehouseUk::Cinema.new('Abbeygate_Picturehouse', 'Abbeygate Picturehouse', '/cinema/Abbeygate_Picturehouse/') }

      before do
        body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'abbeygate-contact-us.html') )
        stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Abbeygate_Picturehouse/Hires_Info/Contact_Us/').to_return( status: 200, body: body, headers: {} )
      end

      it 'returns the post code' do
        subject.must_equal 'IP33 1NE'
      end
    end

    describe '(hackney)' do
      let(:cinema) { PicturehouseUk::Cinema.new('Hackney_Picturehouse', 'Hackney Picturehouse', '/cinema/Hackney_Picturehouse/') }

      before do
        body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'hackney-contact-us.html') )
        stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Hackney_Picturehouse/Hires_Info/Contact_Us/').to_return( status: 200, body: body, headers: {} )
      end

      it 'returns the post code' do
        subject.must_equal 'E8 1HE'
      end
    end

    describe '(komedia)' do
      let(:cinema) { PicturehouseUk::Cinema.new('Dukes_At_Komedia', "Duke's At Komedia", '/cinema/Dukes_At_Komedia/') }

      before do
        body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'dukes-at-komedia-contact-us.html') )
        stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Dukes_At_Komedia/Hires_Info/Contact_Us/').to_return( status: 200, body: body, headers: {} )
      end

      it 'returns the post code' do
        subject.must_equal 'BN1 1UN'
      end
    end
  end

  describe '#screenings' do
    let(:cinema) { PicturehouseUk::Cinema.new('Dukes_At_Komedia', "Duke's At Komedia", '/cinema/Dukes_At_Komedia/') }
    subject { cinema.screenings }

    before do
      dukes_cinema_body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'dukes-at-komedia-cinema.html') )
      stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Dukes_At_Komedia/').to_return( status: 200, body: dukes_cinema_body, headers: {} )
    end

    it 'returns an array of screenings' do
      subject.must_be_instance_of(Array)
      subject.each do |item|
        item.must_be_instance_of(PicturehouseUk::Screening)
      end
    end

    it 'returns screening objects with correct film names' do
      subject.first.film_name.must_equal 'Blue Jasmine'
      subject.last.film_name.must_equal 'Royal Opera House: Manon Lescaut'
    end

    it 'returns screening objects with correct cinema name' do
      subject.each { |s| s.cinema_name.must_equal "Duke's At Komedia" }
    end

    it 'returns screening objects with correct UTC times' do
      subject.first.when.must_equal Time.utc(2013, 10, 14, 20, 0, 0)
      subject.last.when.must_equal Time.utc(2014, 6, 24, 17, 45, 0)
    end
  end

  describe '#street_address' do
    subject { cinema.street_address }

    describe '(abbeygate)' do
      let(:cinema) { PicturehouseUk::Cinema.new('Abbeygate_Picturehouse', 'Abbeygate Picturehouse', '/cinema/Abbeygate_Picturehouse/') }

      before do
        body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'abbeygate-contact-us.html') )
        stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Abbeygate_Picturehouse/Hires_Info/Contact_Us/').to_return( status: 200, body: body, headers: {} )
      end

      it 'returns the street address' do
        subject.must_equal '4 Hatter Street'
      end
    end

    describe '(hackney)' do
      let(:cinema) { PicturehouseUk::Cinema.new('Hackney_Picturehouse', 'Hackney Picturehouse', '/cinema/Hackney_Picturehouse/') }

      before do
        body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'hackney-contact-us.html') )
        stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Hackney_Picturehouse/Hires_Info/Contact_Us/').to_return( status: 200, body: body, headers: {} )
      end

      it 'returns the street address' do
        subject.must_equal '270 Mare Street'
      end
    end

    describe '(komedia)' do
      let(:cinema) { PicturehouseUk::Cinema.new('Dukes_At_Komedia', "Duke's At Komedia", '/cinema/Dukes_At_Komedia/') }

      before do
        body = File.read( File.join(File.dirname(__FILE__), '..', '..', 'fixtures', 'dukes-at-komedia-contact-us.html') )
        stub_request(:get, 'http://www.picturehouses.co.uk/cinema/Dukes_At_Komedia/Hires_Info/Contact_Us/').to_return( status: 200, body: body, headers: {} )
      end

      it 'returns the street address' do
        subject.must_equal '44-47 Gardner Street'
      end
    end
  end
end
