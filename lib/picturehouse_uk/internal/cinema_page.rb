module PicturehouseUk
  # @api private
  module Internal
    # Parses a chunk of HTML to derive movie showing data
    class CinemaPage
      FILM_CSS = '#events .largelist .item'

      # @param [Integer] cinema_id cineworld cinema id
      def initialize(cinema_id)
        @cinema_id = cinema_id
      end

      # break up the page into individual chunks for each film
      # @return [Array<String>] html chunks for a film and it's screenings
      def film_html
        film_nodes.map { |n| n.to_s.gsub(/^\s+/, '') }
      end

      private

      def cinema
        @cinema ||= PicturehouseUk::Internal::Website.new.cinema(@cinema_id)
      end

      def cinema_doc
        @cinema_doc ||= Nokogiri::HTML(cinema)
      end

      def film_nodes
        cinema_doc.css(FILM_CSS)
      end
    end
  end
end
