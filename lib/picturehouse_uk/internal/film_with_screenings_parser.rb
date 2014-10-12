module PicturehouseUk
  # @api private
  module Internal
    # Parses a chunk of HTML to derive movie showing data
    class FilmWithScreeningsParser
      # film name css
      FILM_NAME_CSS = '.movielink'
      # showings css
      SCREENING_CSS = 'a[epoch]'

      # @param [Nokogiri::HTML] film_html a chunk of html
      def initialize(html)
        @html = html
      end

      # The film name
      # @return [String]
      def film_name
        TitleSanitizer.new(raw_film_name).sanitized
      end

      # Showings hashes
      # @return [Array<Hash>]
      def to_a
        doc.css(SCREENING_CSS).map do |node|
          {
            film_name: film_name,
            dimension: dimension
          }.merge(ScreeningParser.new(node).to_hash)
        end
      end

      private

      def dimension
        raw_film_name.match(/3d/i) ? '3d' : '2d'
      end

      def doc
        @doc ||= Nokogiri::HTML(@html)
      end

      def raw_film_name
        @raw_film_name ||= doc.css(FILM_NAME_CSS).children.first.to_s
      end
    end

    # parse an individual screening node
    class ScreeningParser
      # @param [Nokogiri::HTML] node a node with a film screening
      def initialize(node)
        @node = node
      end

      # a attributes of a single screening
      # @return [Hash]
      # @example
      #   Cineworld::Internal::ScreeningParser.new(html).to_hash
      #   => {
      #        booking_url: 'http://...',
      #        time:        <Time>,
      #        variant:     ['imax']
      #      }
      def to_hash
        return unless bookable?
        {
          booking_url: booking_url,
          time:        time,
          variant:     variant
        }
      end

      private

      def booking_url
        @booking_url ||= @node['html']
      end

      def time
        @time ||= Time.utc(1970) + @node['epoch'].to_i
      end

      def variant
        @variant ||= begin
          case @node['class']
          when /big_scream/ then 'baby'
          when /kids_club|toddler_time/ then 'kids'
          when /silver_screen/ then 'silver'
          when /subtitled_cinema/ then 'subtitled'
          else
            ''
          end
        end
      end
    end
  end
end
