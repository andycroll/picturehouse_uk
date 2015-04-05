module PicturehouseUk
  # The object representing a cinema on the Picturehouse UK website
  class Cinema
    # address css
    ADDRESS_CSS = '.static-content #contact-us + p:first'
    # cinema link css
    CINEMA_LINKS_CSS = '.footer .col-sm-3 option + option'

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
                 "http://www.picturehouses.com#{options[:url]}"
               else
                 options[:url]
               end
    end

    # Return basic cinema information for all cinemas
    # @return [Array<PicturehouseUk::Cinema>]
    # @example
    #   PicturehouseUk::Cinema.all
    #   # => [<PicturehouseUK::Cinema ...>, <PicturehouseUK::Cinema ...>, ...]
    def self.all
      cinema_links.map { |link| new_from_link(link) }
    end

    # Find a single cinema
    # @param [String] id the cinema id as used on the picturehouses.co.uk website
    # @return [PicturehouseUk::Cinema, nil]
    # @example
    #   PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   # => <PicturehouseUK::Cinema ...>
    def self.find(id)
      all.find { |cinema| cinema.id == id }
    end

    # Address of the cinema
    # @return [Hash] of different address parts
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.adr
    #   #=> {
    #         street_address:   '44-47 Gardner Street',
    #         extended_address: 'North Laine',
    #         locality:         'Brighton',
    #         region:           'East Sussex',
    #         postal_code:      'BN1 1UN',
    #         country_name: 'United Kingdom'
    #       }
    # @note Uses method naming as at http://microformats.org/wiki/adr
    def adr
      PicturehouseUk::Internal::Parser::Address.new(address_node.to_s).address
    end
    alias_method :address, :adr

    # The second address line of of the cinema
    # @return [String, nil]
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.extended_address
    #   #=> 'North Laine'
    # @note Uses method naming as at http://microformats.org/wiki/adr
    def extended_address
      address[:extended_address]
    end

    # Films with showings scheduled at this cinema
    # @return [Array<PicturehouseUk::Film>]
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.films
    #   # => [<PicturehouseUk::Film ...>, <PicturehouseUk::Film ...>, ...]
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

    # The region (county) of the cinema
    # @return [String]
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.region
    #   #=> 'East Sussex'
    # @note Uses the standard method naming as at http://microformats.org/wiki/adr
    def region
      address[:region]
    end

    # All planned screenings
    # @return [Array<PicturehouseUk::Screening>]
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.screenings
    #   # => [<PicturehouseUk::Screening ...>, <PicturehouseUk::Screening ...>]
    def screenings
      PicturehouseUk::Screening.at(@id)
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
      url =  link.get_attribute('data-href')
      name = link.children.first.to_s.split(' — ')[1]

      new(id:   url.match(%r{/cinema/(.+)$})[1],
          name: name,
          url:  url)
    end

    def address_node
      @address_node ||= info_doc.css(ADDRESS_CSS)
    end

    def info_doc
      @info_doc ||= Nokogiri::HTML(self.class.website.info(id))
    end
  end
end
