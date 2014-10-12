module PicturehouseUk
  # The object representing a cinema on the Picturehouse UK website
  class Cinema
    # address css
    ADDRESS_CSS = '.box6 .txt6'
    # cinema link css
    CINEMA_LINKS_CSS = '#cinemalisthome .cinemas a'

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

    # @param [Hash] options id, name and url of the cinemas
    # @return [PicturehouseUk::Cinema]
    def initialize(options)
      @brand = 'Picturehouse'
      @id    = options[:id]
      @name  = options[:name]
      @slug  = @name.downcase.gsub(/[^0-9a-z ]/, '').gsub(/\s+/, '-')
      @url   = if options[:url][0] == '/'
                 "http://www.picturehouses.co.uk#{options[:url]}"
               else
                 options[:url]
               end
    end

    # Return basic cinema information for all cinemas
    # @return [Array<PicturehouseUk::Cinema>]
    # @example
    #   PicturehouseUk::Cinema.all
    #   # => [<PicturehouseUK::Cinema brand="Picturehouse" name="Duke's At Komedia" slug="dukes-at-komedia" id="Dukes_At_Komedia" url="...">, #=> <PicturehouseUK::Cinema brand="Picturehouse" name="Duke o York's" slug="duke-of-yorks" id="Duke_Of_Yorks" url="...">, ...]
    def self.all
      cinema_links.map { |link| new_from_link(link) }
    end

    # Find a single cinema
    # @param [String] id the cinema id as used on the picturehouses.co.uk website
    # @return [PicturehouseUk::Cinema, nil]
    # @example
    #   PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   # => <PicturehouseUK::Cinema brand="Picturehouse" name="Duke's At Komedia" slug="dukes-at-komedia" id="Dukes_At_Komedia" url="...">
    def self.find(id)
      all.find { |cinema| cinema.id == id }
    end

    # Address of the cinema
    # @return [Hash] of different address parts
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.adr
    #   #=> { street_address: '44-47 Gardner Street', extended_address: 'North Laine', locality: 'Brighton', postal_code: 'BN1 1UN', country_name: 'United Kingdom' }
    # @note Uses the standard method naming as at http://microformats.org/wiki/adr
    def adr
      PicturehouseUk::Internal::AddressParser.new(address_node.to_s).address
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
      address[:extended_address]
    end

    # Films with showings scheduled at this cinema
    # @return [Array<PicturehouseUk::Film>]
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.films
    #   # => [<PicturehouseUk::Film name="Iron Man 3">, <PicturehouseUk::Film name="Star Trek Into Darkness">]
    def films
      PicturehouseUk::Film.at(@id)
    end

    # The name of the cinema (might include brand)
    # @return [String]
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.full_name
    #   #=> "Duke's At Komedia"
    def full_name
      name
    end

    # The locality (town) of the cinema
    # @return [String]
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.locality
    #   #=> 'Brighton'
    # @note Uses the standard method naming as at http://microformats.org/wiki/adr
    def locality
      address[:locality]
    end

    # Post code of the cinema
    # @return [String]
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.postal_code
    #   #=> 'BN1 1UN'
    # @note Uses the standard method naming as at http://microformats.org/wiki/adr
    def postal_code
      address[:postal_code]
    end

    # All planned screenings
    # @return [Array<PicturehouseUk::Screening>]
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.screenings
    #   # => [<PicturehouseUk::Screening film_name="Iron Man 3" cinema_name="Duke's At Komedia" when="..." variant="...">, <PicturehouseUk::Screening ...>]
    def screenings
      film_nodes.map do |node|
        parser = PicturehouseUk::Internal::FilmWithScreeningsParser.new node.to_s
        parser.showings.map do |screening_type, times|
          times.map do |time|
            variant = screening_type == '2d' ? nil : screening_type
            PicturehouseUk::Screening.new parser.film_name, self.name, time, variant
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
      address[:street_address]
    end

    private

    def self.cinema_links
      home_doc.css(CINEMA_LINKS_CSS)
    end

    def self.home_doc
      @home_doc ||= Nokogiri::HTML(website.home)
    end

    def self.website
      @website ||= PicturehouseUk::Internal::Website.new
    end

    def self.new_from_link(link)
      url = link.get_attribute('href')
      new(
        id: url.match(%r(/cinema/(.+)/$))[1],
        name: link.css('span:nth-child(2)').text,
        url:  url
      )
    end

    def address_node
      @address_node ||= contact_us_doc.css(ADDRESS_CSS)
    end

    def contact_us_doc
      @contact_us_doc ||= Nokogiri::HTML(self.class.website.contact_us(id))
    end

    def post_code_index
      address_parts.index { |e| e.match(POSTCODE_REGEX) }
    end
  end
end
