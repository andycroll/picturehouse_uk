module PicturehouseUk
  # @api private
  module Internal
    # Parses a chunk of HTML to derive address
    class AddressParser
      # CSS for address lines
      ADDRESS_LINES_CSS = '.cinemaListBox'

      # regular expression for postal code
      POSTCODE_REGEX = /[A-Z]{1,2}\d{1,2}[A-Z]?\s\d{1,2}[A-Z]{1,2}/

      # @param [String] node the HTML to parse into an address
      # @return [PicturehouseUk::Internal::AddressParser]
      def initialize(html)
        @html = html
      end

      # @return [Hash] contains :street_address, :extended_address, :locality,
      # :postal_code, :country
      # @note Uses the address naming from http://microformats.org/wiki/adr
      def address
        {
          street_address: array[0],
          extended_address: array.length > 3 ? array[1] : nil,
          locality: array[-2],
          postal_code: array[-1],
          country: 'United Kingdom'
        }
      end

      private

      def array
        @array ||= begin
          if standard?
            lines[0..postal_code_index(lines)]
          else
            # this is a horrendous hack for Hackney Picturehouse
            doc.css('p').to_s.split('Box Office')[0].split('<br> ')[1..-1]
          end
        end
      end

      def doc
        @doc ||= Nokogiri::HTML(@html)
      end

      def matched_lines
        @matched_lines ||= begin
          matched = doc.css(ADDRESS_LINES_CSS).map { |n| n.children[0].to_s }
          matched.reject { |e| e == '' }
        end
      end

      def postal_code_index(array)
        array.index { |element| element.match(POSTCODE_REGEX) }
      end

      def lines
        if matched_lines.length > 0 && matched_lines[0].match(/\d+\Z/) # komedia
          ["#{matched_lines[0]} #{matched_lines[1]}"] + matched_lines[2..-1]
        else
          matched_lines
        end
      end

      def standard?
        lines && lines.length > 0
      end
    end
  end
end
