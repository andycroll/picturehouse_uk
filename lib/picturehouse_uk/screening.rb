module PicturehouseUk
  # A single screening of a film on the Picturehouse UK website
  class Screening
    # @return [String] the booking URL on the cinema website
    attr_reader :booking_url
    # @return [String] the cinema name
    attr_reader :cinema_name
    # @return [String] 2d or 3d
    attr_reader :dimension
    # @return [String] the film name
    attr_reader :film_name

    # @param [Hash] options
    def initialize(options)
      @booking_url = options.fetch(:booking_url, nil)
      @cinema_name = options.fetch(:cinema_name)
      @cinema_id   = options.fetch(:cinema_id)
      @dimension   = options.fetch(:dimension, '2d')
      @film_name   = options.fetch(:film_name)
      @time        = options.fetch(:time)
      @variant     = options.fetch(:variant, [])
    end

    # Screenings at a single cinema
    # @param [String] cinema_id the id of the cinema
    # @return [Array<PicturehouseUk::Screening>]
    def self.at(cinema_id)
      screenings(cinema_id).map do |attributes|
        new cinema_hash(cinema_id).merge(attributes)
      end.uniq
    end

    # The UTC time of the screening
    # @return [Time]
    def showing_at
      @showing_at ||= begin
        if @time.utc?
          @time
        else
          TZInfo::Timezone.get('Europe/London').local_to_utc(@time)
        end
      end
    end

    # The date of the screening
    # @return [Date]
    def showing_on
      showing_at.to_date
    end

    # The kinds of screening
    # @return <Array[String]>
    def variant
      @variant.map(&:downcase).sort
    end

    private

    def self.cinema_hash(cinema_id)
      {
        cinema_id: cinema_id,
        cinema_name: PicturehouseUk::Cinema.find(cinema_id).name
      }
    end

    def self.screenings(cinema_id)
      PicturehouseUk::Internal::Parser::Screenings.new(cinema_id).to_a
    end
  end
end
