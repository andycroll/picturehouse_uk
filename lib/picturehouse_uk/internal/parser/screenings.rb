module PicturehouseUk
  # @api private
  module Internal
    # @api private
    module Parser
      # Parses JSON API response into an array of screening hashes
      class Screenings
        def initialize(cinema_id)
          @cinema_id = cinema_id
        end

        # Parse the JSON response into an array of screening attributes
        # @return [Array<Hash>]
        def to_a
          return [] unless json_data['response'] == 'success'
          return [] unless json_data['movies']

          json_data['movies'].flat_map do |movie|
            parse_movie(movie)
          end.compact
        end

        private

        def parse_movie(movie)
          return [] if movie['show_times'].nil? || movie['show_times'].empty?

          movie['show_times'].map do |timing|
            parse_timing(movie, timing)
          end.compact
        end

        def parse_timing(movie, timing)
          # Skip sold out or unavailable screenings
          return nil if timing['SoldoutStatus'] == 2
          return nil unless timing['date_f'] && timing['time']

          # Skip advance booking restrictions if not advertised
          if movie['ABgtToday'] == true && movie['AdvertiseAdvanceBookingDate'] == false
            return nil
          end

          {
            film_name: sanitize_title(movie['Title']),
            dimension: determine_dimension(movie['Title'], timing),
            variant: extract_variants(timing),
            booking_url: booking_url(timing),
            starting_at: parse_datetime(timing['date_f'], timing['time'])
          }
        end

        def sanitize_title(title)
          TitleSanitizer.new(title).sanitized
        end

        def determine_dimension(title, timing)
          # Check title for 3D indicator
          return '3d' if title =~ /3d/i

          # Check timing attributes for 3D
          if timing['SessionAttributesNames']
            return '3d' if timing['SessionAttributesNames'].any? { |attr| attr =~ /3d/i }
          end

          '2d'
        end

        def extract_variants(timing)
          return [] unless timing['SessionAttributesNames']

          variants = []

          timing['SessionAttributesNames'].each do |attribute|
            # Map known attributes to variant types
            variants << 'baby' if attribute =~ /big scream/i
            variants << 'imax' if attribute =~ /imax/i
            variants << 'kids' if attribute =~ /kids|toddler/i
            variants << 'arts' if attribute =~ /nt live|screen arts|rbo|roh|met opera/i
            variants << 'senior' if attribute =~ /silver screen/i
          end

          variants.uniq.sort
        end

        def booking_url(timing)
          return nil unless timing['SessionId']

          # Vista booking URL format
          "https://web.picturehouses.com/order/showtimes/#{@cinema_id}-#{timing['SessionId']}/seats"
        end

        def parse_datetime(date_str, time_str)
          # date_str format: "2024-10-30"
          # time_str format: "19:30"
          return nil unless date_str && time_str

          date_parts = date_str.split('-').map(&:to_i)
          time_parts = time_str.split(':').map(&:to_i)

          # Create Time object in local timezone, then convert to UTC
          Time.new(
            date_parts[0], # year
            date_parts[1], # month
            date_parts[2], # day
            time_parts[0], # hour
            time_parts[1], # minute
            0,             # second
            '+00:00'       # UTC timezone
          )
        rescue StandardError => e
          warn "Failed to parse datetime from #{date_str} #{time_str}: #{e.message}"
          nil
        end

        def json_data
          @json_data ||= api_client.get_movies(@cinema_id)
        end

        def api_client
          @api_client ||= Api.new
        end
      end
    end
  end
end
