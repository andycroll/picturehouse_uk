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
            street_address:   address_lines[0],
            extended_address: extended_address,
            locality:         town,
            region:           region,
            postal_code:      postal_code,
            country_name:     'United Kingdom'.freeze
          }
        end

        private

        def array
          @array ||= begin
            # Split on <br> tags first, then strip all HTML tags from each part
            @html.split(/<br\s*\/?>/).map do |part|
              # Strip all HTML tags and clean up whitespace
              Nokogiri::HTML::DocumentFragment.parse(part).text.strip
            end.reject(&:empty?)
          end
        end

        # Skip the first element (cinema name) and return address lines
        def address_lines
          @address_lines ||= array[1..-1] || []
        end

        def extended_address
          address_lines.length > 4 ? address_lines[1] : nil
        end

        def postal_code
          address_lines[-1]
        end

        def region
          # If there are 4+ address lines (street, town, region, postcode),
          # the region is at -2, otherwise nil
          address_lines.length >= 4 ? address_lines[-2] : nil
        end

        def town
          # Town is always the second-to-last item (before postcode)
          # unless there's a region, then it's third-to-last
          @town ||= address_lines.length >= 4 ? address_lines[-3] : address_lines[-2]
        end
      end
    end
  end
end
