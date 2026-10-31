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
        get("sites").fetch("sites")
      end

      # @param [String] cinema_id zero-padded site id, e.g. '019'
      # @param [Date] date business date
      # @return [Hash] showtimes plus their related films and attributes
      def showtimes(cinema_id, date)
        get("showtimes/by-business-date/#{date.iso8601}",
                   "siteIds" => cinema_id)
      end

      private

      def get(path, query = {})
        client.get(path, query)
      rescue Cinebase::Vista::AuthenticationError
        PicturehouseUk.reject_token!(@client_token)
        raise
      end

      # One client keeps one connection open, so reuse it until the token
      # changes. Picturehouse's API rejects every Connect-Region-Code, so
      # send none.
      def client
        token = PicturehouseUk.token
        if @client.nil? || @client_token != token
          @client_token = token
          @client = Cinebase::Vista::Client.new(base_url: BASE_URL, region_code: nil,
                                                token: token)
        end
        @client
      end
    end
  end
end
