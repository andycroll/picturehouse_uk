module PicturehouseUk

  # Internal utility classes: Do not use
  # @api private
  module Internal

    # Parses a chunk of HTML to derive movie showing data
    class FilmWithScreeningsParser

      # @param [String] film_html a chunk of html
      def initialize(film_html)
        @nokogiri_html = Nokogiri::HTML(film_html)
      end

      # The film name
      # @return [String]
      def film_name
        TitleSanitizer.new(raw_film_name).sanitized
      end



      end

      # Showings
      # @return [Hash]
      # @example
      #   {
      #     "2D" => [Time.utc, Time.utc]
      #   }
      def showings
        @nokogiri_html.css('a[epoch]').inject({}) do |result, link|
          key = case link['class']
            when /big_scream/ then 'baby'
            when /kids_club|toddler_time/ then 'kids'
            when /silver_screen/ then 'silver'
            when /subtitled_cinema/ then 'subtitled'
            else '2d'
          end
          # this is a hack because Time.at() only uses local time
          time = Time.utc(1970)+link['epoch'].to_i

          result.merge(key => (result[key] || []) << time)
        end
      end
    end
  end
end
