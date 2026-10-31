module PicturehouseUk
  # The object representing a cinema on the Picturehouse UK website
  class Cinema < Cinebase::Cinema
    # @!attribute [r] id
    #   @return [String] the zero-padded Vista id of the cinema, e.g. '019'

    # Vista site ids whose page slug differs from the cinema name
    URL_SLUGS = {
      '013' => 'picturehouse-at-fact',
      '030' => 'epsom-picturehouse'
    }.freeze

    # UK postcode, the last line of an address
    POSTCODE = /\A[A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}\z/i.freeze

    # Constructor
    # @param [Integer, String] id the cinema id of the format 19/'019'
    # @return [PicturehouseUk::Cinema]
    def initialize(id)
      @id = id.to_s.rjust(3, '0')
    end

    # Return basic cinema information for all cinemas
    # @return [Array<PicturehouseUk::Cinema>]
    # @example
    #   PicturehouseUk::Cinema.all
    #   #=> [<PicturehouseUk::Cinema>, <PicturehouseUk::Cinema>, ...]
    def self.all
      sites_hash.keys.map { |id| new(id) }
    end

    # @!method address
    #   Address of the cinema
    #   @return [Hash] of different address parts
    #   @see #adr

    # Address of the cinema
    # @return [Hash] contains :street_address, :extended_address,
    # :locality, :region, :postal_code, :country_name
    # @example
    #   cinema = PicturehouseUk::Cinema.new(19)
    #   cinema.adr
    #   #=> {
    #         street_address:   '44-47 Gardner Street',
    #         extended_address: nil,
    #         locality:         'Brighton',
    #         region:           nil,
    #         postal_code:      'BN1 1UN',
    #         country_name:     'United Kingdom'
    #       }
    # @note Uses method naming as at http://microformats.org/wiki/adr
    def adr
      lines = address_lines
      postal_code = lines.pop if lines.last&.match?(POSTCODE)
      street_address = lines.shift
      locality = lines.pop
      {
        street_address:   street_address,
        extended_address: lines.empty? ? nil : lines.join(', '),
        locality:         locality,
        region:           nil,
        postal_code:      postal_code,
        country_name:     'United Kingdom'.freeze
      }
    end

    # Brand of the cinema
    # @return [String] which will always be 'Picturehouse'
    def brand
      'Picturehouse'.freeze
    end

    # The name of the cinema, which often includes the brand
    # @return [String]
    # @example
    #   cinema = PicturehouseUk::Cinema.new(19)
    #   cinema.full_name
    #   #=> "Duke's at Komedia"
    def full_name
      name
    end

    # Latitude of the cinema
    # @return [Float, nil] decimal degrees, or nil when unknown
    # @example
    #   cinema = PicturehouseUk::Cinema.new(19)
    #   cinema.latitude
    #   #=> 50.8247985839844
    def latitude
      coordinates&.first
    end

    # Longitude of the cinema
    # @return [Float, nil] decimal degrees, or nil when unknown
    # @example
    #   cinema = PicturehouseUk::Cinema.new(19)
    #   cinema.longitude
    #   #=> -0.139400005340576
    def longitude
      coordinates&.last
    end

    # The name of the cinema
    # @return [String]
    # @example
    #   cinema = PicturehouseUk::Cinema.new(19)
    #   cinema.name
    #   #=> "Duke's at Komedia"
    def name
      site_hash.dig('name', 'text').to_s
    end

    # The url of the cinema on the Picturehouse website
    # @return [String]
    def url
      "https://www.picturehouses.com/cinema/#{url_slug}"
    end

    # @api private
    def self.sites_hash
      @sites_hash ||= PicturehouseUk::Internal::ApiResponse.new.sites.to_h do |site|
        [site.fetch('id'), site]
      end
    end
    private_class_method :sites_hash

    private

    def address_lines
      address = site_hash.dig('contactDetails', 'addressV2') || {}
      %w(line1 line2 line3 line4).filter_map do |key|
        text = address.dig(key, 'text').to_s.strip
        text unless text.empty?
      end
    end

    # 0, 0 marks a site whose position was never set
    def coordinates
      location = site_hash['location'] || {}
      pair = [location['latitude'], location['longitude']]
      pair.map(&:to_f) if pair.all?(Numeric) && pair.any?(&:nonzero?)
    end

    def site_hash
      @site_hash ||= self.class.send(:sites_hash).fetch(id, {})
    end

    def url_slug
      URL_SLUGS.fetch(id) do
        name.downcase.gsub(/[^a-z0-9]+/, '-').gsub(/\A-|-\z/, '')
      end
    end
  end
end
