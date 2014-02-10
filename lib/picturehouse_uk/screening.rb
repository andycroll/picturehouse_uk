module PicturehouseUk

  # A single screening of a film on the Picturehouse UK website
  class Screening

    # @return [String] the cinema name
    attr_reader :cinema_name
    # @return [String] the film name
    attr_reader :film_name
    # @return [Time] the UTC time of the screening
    attr_reader :when
    # @return [String] the type of screening (2D, 3D, IMAX...)
    attr_reader :variant

    # @param [String] film_name the film name
    # @param [String] cinema_name the cinema name
    # @param [Time] time datetime of the screening (UTC preferred)
    # @param [String] variant the type of showing (e.g. 3d/baby/live)
    def initialize(film_name, cinema_name, time, variant=nil)
      @cinema_name, @film_name, @variant = cinema_name, film_name, variant
      @when = time.utc? ? time : TZInfo::Timezone.get('Europe/London').local_to_utc(time)
    end

    # The date of the screening
    # @return [Date]
    def date
      @when.to_date
    end

    # @deprecated Please use {#variant} instead, I can't spell
    def varient
      warn "Please use #variant instead, I can't spell"
      variant
    end
  end
end
