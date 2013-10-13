module PicturehouseUk

  # Public: The object representing a cinema on the Picturehouse UK website
  class Cinema

    # Public: Returns the String brand of the cinema #=> 'Picturehouse'
    attr_reader :brand
    # Public: Returns the String id of the cinema on the picturehouse website
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

    # Public: Return basic cinema information for all Odeon cinemas
    #
    # Examples
    #
    #   OdeonUk::Cinema.all
    #   # => [<OdeonUk::Cinema brand="Odeon" name="Odeon Tunbridge Wells" slug="odeon-tunbridge-wells" id=23 url="...">, #=> <OdeonUk::Cinema brand="Odeon" name="Odeon Brighton" slug="odeon-brighton" chain_id="71" url="...">, ...]
    #
    # Returns an array of hashes of cinema information.
    def self.all
      cinema_links.map do |link|
        new_from_link link
      end
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

  end
end
