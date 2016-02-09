module PicturehouseUk
  # @api private
  module Internal
    # @api private
    module Parser
      # Parses screenings page into an array of hashes for an individual cinema
      Screenings = Struct.new(:cinema_id) do
        # css for a day of films & screenings
        LISTINGS = '.listings li:not(.dark)'.freeze
        DATE = '.nav-collapse.collapse'.freeze

        # parse the cinema page into an array of screenings attributes
        # @return [Array<Hash>]
        def to_a
          doc.css(LISTINGS).flat_map do |node|
            FilmWithShowtimes.new(node,
                                  date_from_html(node.css(DATE).to_s)).to_a
          end
        end

        private

        def date_from_html(html)
          if html =~ /listings-further-ahead-today/
            Date.now
          else
            html.match(/listings-further-ahead-(\d{4})(\d{2})(\d{2})/) do |m|
              Date.new(m[1].to_i, m[2].to_i, m[3].to_i)
            end
          end
        end

        def doc
          @doc ||= Nokogiri::HTML(page)
        end

        def page
          @page ||= PicturehouseUk::Internal::Website.new.whats_on(cinema_id)
        end
      end
    end

    # @api private
    # collection of timings for a specific film
    FilmWithShowtimes = Struct.new(:node, :date) do
      # film name css
      NAME = '.top-mg-sm a'.freeze
      # variants css
      VARIANTS = '.film-times .col-xs-10'.freeze

      # The film name
      # @return [String]
      def name
        TitleSanitizer.new(raw_name).sanitized
      end

      # Showings hashes
      # @return [Array<Hash>]
      def to_a
        Array(node.css(VARIANTS)).flat_map do |variant|
          Variant.new(variant, date).to_a.map do |hash|
            {
              film_name: name,
              dimension: dimension
            }.merge(hash)
          end
        end
      end

      private

      def dimension
        raw_name =~ /3d/i ? '3d' : '2d'
      end

      def raw_name
        @raw_name ||= node.css(NAME).children.first.to_s
      end
    end

    # @api private
    # variants can have multiple screenings
    Variant = Struct.new(:node, :date) do
      SHOWTIMES  = '.btn'.freeze
      VARIANT    = '.film-type-desc'.freeze
      TRANSLATOR = {
        'Big Scream'    => 'baby',
        'IMAX'          => 'imax',
        "Kids' Club"    => 'kids',
        'NT Live'       => 'arts',
        'Screen Arts'   => 'arts',
        'Silver Screen' => 'senior'
      }.freeze

      # Variant arrays
      # @return [Array<Hash>]
      def to_a
        node.css(SHOWTIMES).map do |node|
          { variant: variant }.merge(Showtime.new(node, date).to_hash)
        end
      end

      private

      def variant
        @variant ||= TRANSLATOR.select do |k, _|
          variant_text.include?(k)
        end.values.uniq
      end

      def variant_text
        @variant_text ||= node.css(VARIANT).to_s
      end
    end

    # @api private
    # parse an individual screening node
    Showtime = Struct.new(:node, :date) do
      def to_hash
        {
          booking_url: booking_url,
          starting_at: starting_at
        }
      end

      private

      def booking_url
        return if href.nil? || href.empty?
        "https://picturehouses.com#{href}"
      end

      def href
        @href ||= node['href']
      end

      def starting_at
        @starting_at ||= begin
          hour, min = node.text.split('.').map(&:to_i)
          date.to_time + (hour * 60 + min) * 60
        end
      end
    end
  end
end
