require 'nokogiri'
require 'tzinfo'
require 'tzinfo/data'

require_relative './picturehouse_uk/version'

require_relative './picturehouse_uk/internal/parser/address'
require_relative './picturehouse_uk/internal/parser/screenings'
require_relative './picturehouse_uk/internal/title_sanitizer'
require_relative './picturehouse_uk/internal/website'

require_relative './picturehouse_uk/cinema'
require_relative './picturehouse_uk/film'
require_relative './picturehouse_uk/screening'

module PicturehouseUk
end
