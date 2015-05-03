module PicturehouseUk
  # @api private
  module Internal
    # @api private
    module Parser
      # Parses screenings page into an array of hashes for an individual cinema
      Screenings = Struct.new(:cinema_id) do
        # css for a day of films & screenings
        LISTINGS = '#today .listings > li, #this-week .listings > li, #further-ahead .listings > li'

        # parse the cinema page into an array of screenings attributes
        # @return [Array<Hash>]
        def to_a
          date = Date.today
          doc.css(LISTINGS).each_with_object([]) do |node, result|
            if date?(node.text)
              date = date_parse(node.text)
            else
              result << FilmWithShowtimes.new(node, date).to_a
            end
          end.flatten
        end

        private

        def date_parse(text)
          Date.parse(text)
        rescue ArgumentError
          nil
        end

        def doc
          @doc ||= Nokogiri::HTML(page)
        end

        def date?(text)
          !!text.match(/(Mon|Tues|Wednes|Thurs|Fri|Satur|Sun)day \d{1,2}(st|nd|th) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)/)
        end

        def page
          @page ||= PicturehouseUk::Internal::Website.new.cinema(cinema_id)
        end
      end
    end

    FilmWithShowtimes = Struct.new(:node, :date) do
      # film name css
      NAME = '.top-mg-sm a'
      # variants css
      VARIANTS = '.film-times .col-xs-10'

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
        raw_name.match(/3d/i) ? '3d' : '2d'
      end

      def raw_name
        @raw_name ||= node.css(NAME).children.first.to_s
      end
    end

    # variants can have multiple screenings
    Variant = Struct.new(:node, :date) do
      SHOWTIMES  = '.btn'
      VARIANT    = '.film-type-desc'
      TRANSLATOR = {
        'Big Scream'    => 'baby',
        'IMAX'          => 'imax',
        "Kids' Club"    => 'kids',
        'NT Live'       => 'arts',
        'Screen Arts'   => 'arts',
        'Silver Screen' => 'senior'
      }

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

    # parse an individual screening node
    Showtime = Struct.new(:node, :date) do
      def to_hash
        {
          booking_url: node['href'],
          time:        time
        }
      end

      private

      def time
        @time ||= begin
          hour, min = node.text.split('.').map(&:to_i)
          date.to_time + (hour * 60 + min) * 60
        end
      end
    end
  end
end
