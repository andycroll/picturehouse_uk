module PicturehouseUk

  # The object representing a cinema on the Picturehouse UK website
  class Cinema

    # @return [String] the brand of the cinema
    attr_reader :brand
    # @return [String] the id of the cinema on the Picturehouse website
    attr_reader :id
    # @return [String] the name of the cinema
    attr_reader :name
    # @return [String] the slug of the cinema
    attr_reader :slug
    # @return [String] the url of the cinema on the Picturehouse website
    attr_reader :url

    # @param [String] id cinema id from the site
    # @param [String] name cinema name
    # @param [String] url url on Picturehouse website
    # @return [PicturehouseUk::Cinema]
    def initialize(id, name, url)
      @brand = 'Picturehouse'
      @id    = id
      @name  = name
      @slug  = name.downcase.gsub(/[^0-9a-z ]/,'').gsub(/\s+/, '-')
      @url   = (url[0] == '/') ? "http://www.picturehouses.co.uk#{url}" : url
    end

    # Return basic cinema information for all cinemas
    # @return [Array<PicturehouseUk::Cinema>]
    # @example
    #   PicturehouseUk::Cinema.all
    #   # => [<PicturehouseUK::Cinema brand="Picturehouse" name="Duke's At Komedia" slug="dukes-at-komedia" id="Dukes_At_Komedia" url="...">, #=> <PicturehouseUK::Cinema brand="Picturehouse" name="Duke o York's" slug="duke-of-yorks" id="Duke_Of_Yorks" url="...">, ...]
    def self.all
      cinema_links.map do |link|
        new_from_link link
      end
    end

    # Find a single cinema
    # @param [String] id the cinema id as used on the picturehouses.co.uk website
    # @return [PicturehouseUk::Cinema, nil]
    # @example
    #   PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   # => <PicturehouseUK::Cinema brand="Picturehouse" name="Duke's At Komedia" slug="dukes-at-komedia" id="Dukes_At_Komedia" url="...">
    def self.find(id)
      all.select { |cinema| cinema.id == id }[0]
    end

    # Films with showings scheduled at this cinema
    # @return [Array<PicturehouseUk::Film>]
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.films
    #   # => [<PicturehouseUk::Film name="Iron Man 3">, <PicturehouseUk::Film name="Star Trek Into Darkness">]
    def films
      film_nodes.map do |node|
        parser = PicturehouseUk::Internal::FilmWithScreeningsParser.new node.to_s
        PicturehouseUk::Film.new parser.film_name
      end.uniq
    end

    # All planned screenings
    # @return [Array<PicturehouseUk::Screening>]
    # @example
    #   cinema = PicturehouseUk::Cinema.find('Dukes_At_Komedia')
    #   cinema.screenings
    #   # => [<PicturehouseUk::Screening film_name="Iron Man 3" cinema_name="Duke's At Komedia" when="..." varient="...">, <PicturehouseUk::Screening ...>]
    def screenings
      film_nodes.map do |node|
        parser = PicturehouseUk::Internal::FilmWithScreeningsParser.new node.to_s
        parser.showings.map do |screening_type, times|
          times.map do |time|
            varient = screening_type == '2d' ? nil : screening_type
            PicturehouseUk::Screening.new parser.film_name, self.name, time, varient
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
