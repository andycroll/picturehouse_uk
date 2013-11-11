module PicturehouseUk

  # The object representing a cinema on the Picturehouse UK website
  class Cinema

    # @return [String] the brand of the cinema
    attr_reader :brand
    # @return [String] the id of the cinema on the Picturehouse website
    attr_reader :id
    # @return [String] the name of the cinema
    attr_reader :name
    # @return [String] the slug of the cinema
    attr_reader :slug
    # @return [String] the url of the cinema on the Picturehouse website
    attr_reader :url

    # @param [String] id cinema id from the site
    # @param [String] name cinema name
    # @param [String] url url on Picturehouse website
    # @return [PicturehouseUk::Cinema]
    def initialize(id, name, url)
      @brand = 'Picturehouse'
      @id    = id
      @name  = name
      @slug  = name.downcase.gsub(/[^0-9a-z ]/,'').gsub(/\s+/, '-')
      @url   = (url[0] == '/') ? "http://www.picturehouses.co.uk#{url}" : url
    end

    # Return basic cinema information for all cinemas
    # @return [Array<PicturehouseUk::Cinema>]
    # @example
    #   PicturehouseUk::Cinema.all
    #   # => [<PicturehouseUK::Cinema brand="Picturehouse" name="Duke's At Komedia" slug="dukes-at-komedia" id="Dukes_At_Komedia" url="...">, #=> <PicturehouseUK::Cinema brand="Picturehouse" name="Duke o York's" slug="duke-of-yorks" id="Duke_Of_Yorks" url="...">, ...]
    def self.all
      cinema_links.map do |link|
        new_from_link link
      end
    end

    # Find a single cinema
    # @param [String] id the cinema id as used on the picturehouses.co.uk website
    # @return [PicturehouseUk::Cinema, nil]
    # @example
    #   PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   # => <PicturehouseUK::Cinema brand="Picturehouse" name="Duke's At Komedia" slug="dukes-at-komedia" id="Dukes_At_Komedia" url="...">
    def self.find(id)
      all.select { |cinema| cinema.id == id }[0]
    end

    # Address of the cinema
    # @return [Hash] of different address parts
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.adr
    #   #=> { street_address: '44-47 Gardner Street', extended_address: 'North Laine', locality: 'Brighton', postal_code: 'BN1 1UN', country_name: 'United Kingdom' }
    # @note Uses the standard method naming as at http://microformats.org/wiki/adr
    def adr
      {
        street_address: street_address,
        extended_address: extended_address,
        locality: locality,
        postal_code: postal_code,
        country: 'United Kingdom'
      }
    end
    alias_method :address, :adr

    # The second address line of of the cinema
    # @return [String, nil]
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.extended_address
    #   #=> 'North Laine'
    # @note Uses the standard method naming as at http://microformats.org/wiki/adr
    def extended_address
      address_strings.length > 3 ? address_strings[1] : nil
    end

    # Films with showings scheduled at this cinema
    # @return [Array<PicturehouseUk::Film>]
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.films
    #   # => [<PicturehouseUk::Film name="Iron Man 3">, <PicturehouseUk::Film name="Star Trek Into Darkness">]
    def films
      film_nodes.map do |node|
        parser = PicturehouseUk::Internal::FilmWithScreeningsParser.new node.to_s
        PicturehouseUk::Film.new parser.film_name
      end.uniq
    end

    # The locality (town) of the cinema
    # @return [String]
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.locality
    #   #=> 'Brighton'
    # @note Uses the standard method naming as at http://microformats.org/wiki/adr
    def locality
      address_strings[-2]
    end

    # Post code of the cinema
    # @return [String]
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.postal_code
    #   #=> 'BN1 1UN'
    # @note Uses the standard method naming as at http://microformats.org/wiki/adr
    def postal_code
      address_strings[-1]
    end

    # All planned screenings
    # @return [Array<PicturehouseUk::Screening>]
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.screenings
    #   # => [<PicturehouseUk::Screening film_name="Iron Man 3" cinema_name="Duke's At Komedia" when="..." varient="...">, <PicturehouseUk::Screening ...>]
    def screenings
      film_nodes.map do |node|
        parser = PicturehouseUk::Internal::FilmWithScreeningsParser.new node.to_s
        parser.showings.map do |screening_type, times|
          times.map do |time|
            varient = screening_type == '2d' ? nil : screening_type
            PicturehouseUk::Screening.new parser.film_name, self.name, time, varient
          end
        end
      end.flatten
    end

    # The street adress of the cinema
    # @return a String
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.street_address
    #   #=> '44-47 Gardner Street'
    # @note Uses the standard method naming as at http://microformats.org/wiki/adr
    def street_address
      address_strings[0]
    end

    private

    def self.cinema_links
      parsed_homepage.css('#cinemalisthome .cinemas a')
    end

    def self.homepage_response
      @homepage_response ||= HTTParty.get('http://www.picturehouses.co.uk/')
    end

    def self.new_from_link(link)
      url  = link.get_attribute('href')
      id   = url.match(/\/cinema\/(.+)\/$/)[1]
      name = link.css('span:nth-child(2)').text
      new id, name, url
    end

    def self.parsed_homepage
      Nokogiri::HTML(homepage_response)
    end

    def address_parts
      if pure_address_parts.length > 0 && pure_address_parts[0].match(/\d+\Z/)
        ["#{pure_address_parts[0]} #{pure_address_parts[1]}"] + pure_address_parts[2..-1]
      else
        pure_address_parts
      end
    end

    def address_strings
      if address_parts && address_parts.length > 0
        address_parts[0..post_code_index]
      else
        # this is a horrendous hack for Hackney Picturehouse
        address_node.css('p').to_s.split('Box Office')[0].split('<br> ')[1..-1]
      end
    end

    def address_node
      parsed_contact_us.css('.box6 .txt6')
    end

    def contact_us_response
      @contact_us_response ||= HTTParty.get("#{@url}Hires_Info/Contact_Us/")
    end

    def cinema_response
      @cinema_response ||= HTTParty.get(@url)
    end

    def film_nodes
      parsed_cinema.css('.box8_content .largelist .item')
    end

    def parsed_cinema
      Nokogiri::HTML(cinema_response)
    end

    def parsed_contact_us
      Nokogiri::HTML(contact_us_response)
    end

    def post_code_index
      address_parts.index { |e| e.match /[A-Z]{1,2}\d{1,2}[A-Z]?\s\d{1,2}[A-Z]{1,2}/ }
    end

    def pure_address_parts
      @pure_address_parts = address_node.css('.cinemaListBox').map do |e|
        e.children[0].to_s
      end.select { |e| e != '' }
    end
  end
end
