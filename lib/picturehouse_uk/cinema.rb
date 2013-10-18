module PicturehouseUk

  # Public: The object representing a cinema on the Picturehouse UK website
  class Cinema

    # Public: Returns the String brand of the cinema #=> 'Picturehouse'
    attr_reader :brand
    # Public: Returns the String id of the cinema on the Picturehouse website
    attr_reader :id
    # Public: Returns the String name of the cinema
    attr_reader :name
    # Public: Returns the String slug of the cinema
    attr_reader :slug
    # Public: Returns the String url of the cinema's page on picturehouses.co.uk
    attr_reader :url

    # Public: Initialize a cinema
    #
    # id   - String of the cinema on the picturehouse website
    # name - String of cinema name
    # url  - String of cinema url on the picturehouse website
    def initialize(id, name, url)
      @brand = 'Picturehouse'
      @id    = id
      @name  = name
      @slug  = name.downcase.gsub(/[^0-9a-z ]/,'').gsub(/\s+/, '-')
      @url   = (url[0] == '/') ? "http://www.picturehouses.co.uk#{url}" : url
    end

    # Public: Return basic cinema information for all Picturehouse cinemas
    #
    # Examples
    #
    #   PicturehouseUk::Cinema.all
    #   # => [<PicturehouseUK::Cinema brand="Picturehouse" name="Duke's At Komedia" slug="dukes-at-komedia" id="Dukes_At_Komedia" url="...">, #=> <PicturehouseUK::Cinema brand="Picturehouse" name="Duke o York's" slug="duke-of-yorks" id="Duke_Of_Yorks" url="...">, ...]
    #
    # Returns an array of hashes of cinema information.
    def self.all
      cinema_links.map do |link|
        new_from_link link
      end
    end

    # Public: Return single cinema information for an Odeon cinema
    #
    # string - a string representing the cinema id
    #
    # Examples
    #
    #   PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   # => <PicturehouseUK::Cinema brand="Picturehouse" name="Duke's At Komedia" slug="dukes-at-komedia" id="Dukes_At_Komedia" url="...">
    #
    # Returns an PicturehouseUk::Cinema or nil if none was found
    def self.find(id)
      all.select { |cinema| cinema.id == id }[0]
    end

    # Public: Returns screenings for a Picturehouse cinema
    #
    # Examples
    #
    #   cinema = PicturehouseUk::Cinema.find('71')
    #   cinema.screenings
    #   # => [<PicturehouseUk::Screening film_name="Iron Man 3" cinema_name="Duke's At Komedia" when="..." varient="...">, <PicturehouseUk::Screening ...>]
    #
    # Returns an array of Odeon::Screening objects
    def screenings
      film_nodes.map do |node|
        parser = PicturehouseUk::Internal::FilmWithScreeningsParser.new node.to_s
        parser.showings.map do |screening_type, times|
          times.map do |time|
            varient = screening_type == '2d' ? nil : screening_type
            PicturehouseUk::Screening.new parser.film_name, self.name, time.strftime('%d/%m/%Y'), time.strftime('%H:%M:%S'), varient
          end
        end
      end.flatten
    end

    private

    def self.cinema_links
      parsed_homepage.css('#cinemalisthome .cinemas a')
    end

    def self.homepage_response
      @homepage_response ||= HTTParty.get('http://www.picturehouses.co.uk/')
    end

    def self.new_from_link(link)
      url  = link.get_attribute('href')
      id   = url.match(/\/cinema\/(.+)\/$/)[1]
      name = link.css('span:nth-child(2)').text
      new id, name, url
    end

    def self.parsed_homepage
      Nokogiri::HTML(homepage_response)
    end

    def cinema_response
      @cinema_response ||= HTTParty.get(@url)
    end

    def film_nodes
      parsed_cinema.css('.box8_content .largelist .item')
    end

    def parsed_cinema
      Nokogiri::HTML(cinema_response)
    end

  end
end
