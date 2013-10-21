module PicturehouseUk

  # Public: The object representing a screening of a film on the Picturehouse UK website
  class Screening

    # Public: Returns the String name of the cinema
    attr_reader :cinema_name
    # Public: Returns the String name of the film
    attr_reader :film_name
    # Public: Returns the Time of the screening
    attr_reader :when
    # Public: Returns the Type of screening (3d, baby, kids, live)
    attr_reader :varient

    # Public: Initialize a screening
    #
    # film_name   - String of the film name
    # cinema_name - String of the cinema name on the Picturehouse website
    # time        - DateTime representing the time of the screening, UTC preferred
    # varient     - String representing the type of showing (e.g. 3d/baby/live)
    def initialize(film_name, cinema_name, time, varient=nil)
      @cinema_name, @film_name, @varient = cinema_name, film_name, varient
      @when = time.utc? ? time : TZInfo::Timezone.get('Europe/London').local_to_utc(time)
    end

    # Public: The Date of the screening
    #
    # Returns a Date
    def date
      @when.to_date
    end
  end
end
