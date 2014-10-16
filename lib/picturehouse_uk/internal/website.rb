require 'open-uri'

module PicturehouseUk
  # @api private
  module Internal
    # fetches pages from the picturehouse.co.uk website
    class Website
      # get the cinema page with showings for passed id
      # @return [String]
      def cinema(id)
        get("cinema/#{id}/")
      end

      # get the cinema contact information page for passed id
      # @return [String]
      def contact_us(id)
        get("cinema/#{id}/Hires_Info/Contact_Us/")
      end

      # get the home page
      # @return [String]
      def home
        get(nil)
      end

      # get the cinema page containing all upcoming films and screenings
      # @return [String]
      def whatson(id)
        get("whatson?cinema=#{id}")
      end

      private

      def get(path)
        open("http://www.picturehouses.co.uk/#{path}").read
      end
    end
  end
end
