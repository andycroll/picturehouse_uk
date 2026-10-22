# frozen_string_literal: true

require "json"

module PicturehouseUk
  module Internal
    # Reads the public guest token from the ticketing site's page data
    class GuestToken < Cinebase::Vista::GuestToken
      PAGE_URL = "https://web.picturehouses.com/"

      private

      # The ticketing site serves the same page data for unknown paths.
      def accepted_statuses
        %w[200 404]
      end

      def bundled_curl
        File.expand_path("../../../vendor/curl-impersonate/bin/curl-impersonate", __dir__)
      end

      def extract_token(html)
        script = html[%r{<script id="__NEXT_DATA__"[^>]*>(.*?)</script>}m, 1].to_s
        JSON.parse(script).dig("props", "pageProps", "environment", "gasToken")
      end
    end
  end
end
