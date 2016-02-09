module PicturehouseUk
  # The object representing a cinema on the Picturehouse UK website
  class Cinema < Cinebase::Cinema
    # address css
    ADDRESS_CSS = '.static-content #contact-us + p:first'.freeze
    # cinema link css
    CINEMA_LINKS_CSS = '.footer .col-sm-3 option + option'.freeze

    # @!attribute [r] id
    #   @return [Integer] the numeric id of the cinema on the Cineworld website

    # @!method initialize(options)
    #   Constructor
    #   @param [String] id the cinema id of the cinema in capitalized snake case
    #   @return [PicturehouseUk::Cinema]

    # Return basic cinema information for all cinemas
    # @return [Array<PicturehouseUk::Cinema>]
    # @example
    #   PicturehouseUk::Cinema.all
    #   #=> [<PicturehouseUk::Cinema>, <PicturehouseUk::Cinema>, ...]
    def self.all
      cinema_hash.keys.map { |id| new(id) }
    end

    # @api private
    def self.cinema_hash
      @cinema_hash ||= ListParser.new(cinema_links).to_hash
    end

    # @!method address
    #   Address of the cinema
    #   @return [Hash] of different address parts
    #   @see #adr

    # Address of the cinema
    # @return [Hash] contains :street_address, :extended_address,
    # :locality, :postal_code, :country
    # @example
    #   cinema = PicturehouseUk::Cinema.new('Dukes_At_Komedia')
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

    # Brand of the cinema
    # @return [String] which will always be 'Picturehouse'
    # @example
    #   cinema = PicturehouseUk::Cinema.new('Dukes_At_Komedia')
    #   cinema.brand
    #   #=> 'Picturehouse'
    def brand
      'Picturehouse'.freeze
    end

    # @!method country_name
    #   Country of the cinema
    #   @return [String] which will always be 'United Kingdom'
    #   @example
    #     cinema = PicturehouseUk::Cinema.new('Dukes_At_Komedia')
    #     cinema.country_name
    #     #=> 'United Kingdom'

    # @!method extended_address
    #   The second address line of the cinema
    #   @return [String]
    #   @example
    #     cinema = PicturehouseUk::Cinema.new('Dukes_At_Komedia')
    #     cinema.extended_address
    #     #=> 'North Laine'

    # The name of the cinema (might include brand)
    # @return [String]
    # @example
    #   cinema = PicturehouseUk::Cinema.new('Dukes_At_Komedia')
    #   cinema.full_name
    #   #=> "Duke's At Komedia"
    def full_name
      name
    end

    # @!method locality
    #   The locality (town) of the cinema
    #   @return [String]
    #   @example
    #     cinema = PicturehouseUk::Cinema.new('Dukes_At_Komedia')
    #     cinema.locality
    #     #=> 'Brighton'

    # The name of the cinema
    # @return [String]
    # @example
    #   cinema = PicturehouseUk::Cinema.new('Dukes_At_Komedia')
    #   cinema.name
    #   #=> "Duke's At Komedia"
    def name
      self.class.cinema_hash.fetch(id, {})[:name]
    end

    # @!method postal_code
    #   Post code of the cinema
    #   @return [String]
    #   @example
    #     cinema = PicturehouseUk::Cinema.new('Dukes_At_Komedia')
    #     cinema.postal_code
    #     #=> 'BN1 1UN'

    # @!method region
    #   The region (county) of the cinema if provided
    #   @return [String]
    #   @example
    #     cinema = PicturehouseUk::Cinema.new('Dukes_At_Komedia')
    #     cinema.region
    #     #=> 'East Sussex'

    # @!method slug
    #   The URL-able slug of the cinema
    #   @return [String]
    #   @example
    #     cinema = PicturehouseUk::Cinema.new('Dukes_At_Komedia')
    #     cinema.slug
    #     #=> 'dukes-at-komedia'

    # @!method street_address
    #   The street address of the cinema
    #   @return [String]
    #   @example
    #     cinema = PicturehouseUk::Cinema.new('Dukes_At_Komedia')
    #     cinema.street_address
    #     #=> '44-47 Gardner Street'

    # The url of the cinema on the Picturehouse website
    # @return [String]
    def url
      "http://www.picturehouses.com#/cinema/#{id}"
    end

    private

    def self.cinema_links
      home_doc.css(CINEMA_LINKS_CSS)
    end
    private_class_method :cinema_links

    def self.home_doc
      @home_doc ||=
        Nokogiri::HTML(PicturehouseUk::Internal::Website.new.home)
    end
    private_class_method :home_doc

    def address_node
      @address_node ||= info_doc.css(ADDRESS_CSS)
    end

    def info_doc
      @info_doc ||=
        Nokogiri::HTML(PicturehouseUk::Internal::Website.new.info(id))
    end

    # @api private
    # Utility class to parse the links spat out from the options
    class ListParser
      def initialize(nodes)
        @nodes = nodes
      end

      def to_hash
        @nodes.each_with_object({}) do |node, result|
          result[id(node)] = { name: name(node), url: url(node) }
        end
      end

      private

      def id(node)
        url(node).match(%r{/cinema/(.+)$})[1]
      end

      def name(node)
        node.children.first.to_s.split(' — ')[1]
      end

      def url(node)
        node.get_attribute('data-href')
      end
    end
  end
end
