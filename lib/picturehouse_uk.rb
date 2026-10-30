require 'json'

require 'cinebase'
require 'cinebase/vista'

require_relative './picturehouse_uk/version'

require_relative './picturehouse_uk/internal/api_response'
require_relative './picturehouse_uk/internal/guest_token'
require_relative './picturehouse_uk/internal/title_sanitizer'

require_relative './picturehouse_uk/internal/parser/api/showtime'

require_relative './picturehouse_uk/cinema'
require_relative './picturehouse_uk/performance'

# picturehouse_uk gem
module PicturehouseUk
  AuthenticationError = Cinebase::Vista::AuthenticationError

  extend Cinebase::Vista::TokenHolder

  # @api private
  def self.guest_token_class
    Internal::GuestToken
  end
end
