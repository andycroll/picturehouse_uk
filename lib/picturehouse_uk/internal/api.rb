require 'net/http'
require 'json'
require 'openssl'

module PicturehouseUk
  # @api private
  module Internal
    # Fetches JSON data from the Picturehouse API
    class Api
      API_BASE = 'https://www.picturehouses.com'.freeze
      API_ENDPOINT = '/api/get-movies-ajax'.freeze

      # Fetch movie data for a cinema
      # @param cinema_id [String] the cinema ID
      # @param date [String] the date in YYYY-MM-DD format, or 'show_all_dates'
      # @return [Hash] parsed JSON response
      def get_movies(cinema_id, date = 'show_all_dates')
        uri = URI("#{API_BASE}#{API_ENDPOINT}")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(uri.path)
        request.set_form_data(
          'start_date' => date,
          'cinema_id' => cinema_id,
          'filters' => []
        )

        response = http.request(request)

        return {} unless response.is_a?(Net::HTTPSuccess)

        JSON.parse(response.body)
      rescue StandardError => e
        warn "Failed to fetch movies for cinema #{cinema_id}: #{e.message}"
        {}
      end
    end
  end
end
