module PicturehouseUk
  # @api private
  module Internal
    module Parser
      # Parses a chunk of HTML to derive address
      class Address
        # @param [String] node the HTML to parse into an address
        # @return [PicturehouseUk::Internal::AddressParser]
        def initialize(html)
          @html = html.to_s
        end

        # @return [Hash] contains :street_address, :extended_address, :locality,
        # :postal_code, :country
        # @note Uses the address naming from http://microformats.org/wiki/adr
        def address
          {
            street_address:   array[1],
            extended_address: array.length > 5 ? array[2] : nil,
            locality:         town,
            region:           array[-2] == town ? nil : array[-2],
            postal_code:      array[-1],
            country_name:     'United Kingdom'.freeze
          }
        end

        private

        def town
          @town ||= array[0].to_s.split(', ')[-1]
        end

        def array
          @array ||= Array(@html.gsub(/\<.?p.?\>/, '').split('<br>'))
        end
      end
    end
  end
end
