require 'open-uri'
require 'openssl'

module PicturehouseUk
  # @api private
  module Internal
    # fetches pages from the picturehouse.com website
    class Website
      # get the cinema page with showings for passed id
      # @return [String]
      def cinema(id)
        get("cinema/#{id}")
      end

      # get the cinema contact information page for passed id
      # @return [String]
      def information(id)
        get("cinema/#{id}/information")
      rescue OpenURI::HTTPError
        ''
      end

      # get the home page
      # @return [String]
      def home
        get(nil)
      end

      private

      def get(path)
        # SSL verification doesn't work on picturehouses.com
        URI.open("https://www.picturehouses.com/#{path}",
                 ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read
      end
    end
  end
end
