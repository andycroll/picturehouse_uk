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

  # A raw guest JWT, without the "Bearer " prefix. Never persisted by the gem.
  class << self
    attr_accessor :token

    # Explicit acquisition/renewal; ordinary API calls never launch a subprocess.
    def acquire_token!(curl: nil)
      self.token = Internal::GuestToken.new(curl: curl).fetch
    end
  end
end
