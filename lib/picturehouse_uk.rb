require 'httparty'
require 'nokogiri'
require 'tzinfo'
require 'tzinfo/data'

require_relative './picturehouse_uk/version'

require_relative './picturehouse_uk/internal/address_parser'
require_relative './picturehouse_uk/internal/cinema_page'
require_relative './picturehouse_uk/internal/film_with_screenings_parser'
require_relative './picturehouse_uk/internal/title_sanitizer'
require_relative './picturehouse_uk/internal/website'

require_relative './picturehouse_uk/cinema'
require_relative './picturehouse_uk/film'
require_relative './picturehouse_uk/screening'

module PicturehouseUk
end
