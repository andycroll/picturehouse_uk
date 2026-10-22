# frozen_string_literal: true

require "date"

module PicturehouseUk
  # Internal utility classes: Do not use
  # @api private
  module Internal
    # Fetches cinema and showtime data from the Vista API behind picturehouses.com
    class ApiResponse
      BASE_URL = "https://digital-api.picturehouses.com/ocapi/v1/"

      # @return [Array<Hash>] cinemas
      def sites
        client.get("sites").fetch("sites")
      end

      # @param [String] cinema_id zero-padded site id, e.g. '019'
      # @param [Date] date business date
      # @return [Hash] showtimes plus their related films and attributes
      def showtimes(cinema_id, date)
        client.get("showtimes/by-business-date/#{date.iso8601}",
                   "siteIds" => cinema_id)
      end

      private

      # Picturehouse's API rejects every Connect-Region-Code, so send none.
      def client
        Cinebase::Vista::Client.new(base_url: BASE_URL, region_code: nil,
                                    token: PicturehouseUk.token)
      end
    end
  end
end
