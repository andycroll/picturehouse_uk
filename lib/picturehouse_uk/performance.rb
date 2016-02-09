module PicturehouseUk
  # A single screening of a film on the Picturehouse UK website
  class Performance < Cinebase::Performance
    # @!attribute [r] booking_url
    #   @return [String] the booking URL on the cinema website
    # @!attribute [r] cinema_name
    #   @return [String] the cinema name
    # @!attribute [r] cinema_id
    #   @return [String] the cinema id
    # @!attribute [r] dimension
    #   @return [String] 2d or 3d
    # @!attribute [r] film_name
    #   @return [String] the film name

    # @!method initialize(options)
    #   @param [Hash] options options hash
    #   @option options [String] :booking_url (nil) buying url for the screening
    #   @option options [String] :cinema_name name of the cinema
    #   @option options [String] :cinema_id website id of the cinema
    #   @option options [String] :dimension ('2d') dimension of the screening
    #   @option options [String] :film_name name of the film
    #   @option options [Time] :starting_at listed start time of the performance

    # Screenings at a single cinema
    # @param [String] cinema_id the id of the cinema
    # @return [Array<PicturehouseUk::Screening>]
    def self.at(cinema_id)
      screenings(cinema_id).map do |attributes|
        new cinema_hash(cinema_id).merge(attributes)
      end.uniq
    end

    # @!method showing_on
    #   The date of the screening
    #   @return [Date]

    # @!method starting_at
    #   UTC time of the screening
    #   @return [Time]

    # @!method variant
    #   The kinds of screening (IMAX, kids, baby, senior)
    #   @return <Array[String]>

    # private

    def self.cinema_hash(cinema_id)
      {
        cinema_id: cinema_id,
        cinema_name: PicturehouseUk::Cinema.new(cinema_id).name
      }
    end
    private_class_method :cinema_hash

    def self.screenings(cinema_id)
      PicturehouseUk::Internal::Parser::Screenings.new(cinema_id).to_a
    end
    private_class_method :screenings
  end
end
