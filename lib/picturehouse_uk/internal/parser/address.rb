module PicturehouseUk
  # @api private
  module Internal
    # Parses a chunk of HTML to derive address
    class AddressParser
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
          street_address: array[1],
          extended_address: array.length > 5 ? array[2] : nil,
          locality: town,
          region: array[-2] == town ? nil : array[-2],
          postal_code: array[-1],
          country: 'United Kingdom'
        }
      end

      private

      def town
        @town ||= array[0].split(', ')[-1]
      end

      def array
        @array ||= @html.gsub(/\<.?p.?\>/, '').split('<br>')
      end
    end
  end
end
