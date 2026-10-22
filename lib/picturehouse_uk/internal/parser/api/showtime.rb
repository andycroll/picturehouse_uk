# frozen_string_literal: true

require "time"

module PicturehouseUk
  # @api private
  module Internal
    module Parser
      module Api
        # Parses a single Vista showtime into performance attributes
        class Showtime
          BOOKING_URL = "https://web.picturehouses.com/order/showtimes/%s/seats"

          # Vista attribute names, stripped
          VARIANTS = {
            "AD" => "audio_described",
            "Kids' Club" => "kids",
            "Q&A" => "q&a",
            "Relaxed" => "relaxed",
            "Screen Arts" => "arts",
            "Silver Screen" => "senior",
            "Subtitled" => "subtitled",
            "Subtitled (Captioned)" => "subtitled",
            "Toddler Time" => "kids",
            "Watch with Baby" => "baby"
          }.freeze

          # @param [Hash] data one showtime
          # @param [Hash{String => Hash}] films related films keyed by id
          # @param [Hash{String => Hash}] attributes related attributes keyed by id
          def initialize(data, films:, attributes:)
            @data = data
            @films = films
            @attributes = attributes
          end

          # @return [Hash] options for PicturehouseUk::Performance.new
          def to_hash
            {
              booking_url: format(BOOKING_URL, @data.fetch("id")),
              dimension: @data["requires3dGlasses"] ? "3d" : "2d",
              festival: Cinebase::Festival.from_title(title, year: starting_at.year),
              film_name: TitleSanitizer.new(title).sanitized,
              film_year: Cinebase::TitleSanitizer.film_year(title),
              starting_at: starting_at,
              variant: variant
            }
          end

          private

          def starting_at
            Time.iso8601(@data.dig("schedule", "startsAt")).utc
          end

          def title
            @films.fetch(@data.fetch("filmId")).dig("title", "text")
          end

          def variant
            @data.fetch("attributeIds", []).filter_map do |id|
              name = @attributes.dig(id, "name", "text").to_s.strip
              VARIANTS[name.delete_prefix("+ ")]
            end.uniq
          end
        end
      end
    end
  end
end
