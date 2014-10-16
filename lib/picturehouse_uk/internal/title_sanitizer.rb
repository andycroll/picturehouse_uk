module PicturehouseUk
  # @api private
  module Internal
    # Sanitize and standardize film titles
    class TitleSanitizer
      # strings and regex to be removed
      REMOVE = [
        /\s\[(AS LIVE: )?[ACPGU1258]+\]/, # regular certificate
        /\s+[23][dD]/,                    # 2d or 3d from title
        /\s\[NO CERT\]/,                  # no certificate
        /\s\[\]/,                         # blank certificate
        /ourscreen\: /,                   # ourscreen
        /\s\(Re(\: \d{0,4})?\)/i,         # Re-release
        /\s\[CERT TBC\]/,                 # certificate TBC
      ]

      # regexes and their replacements
      REPLACE = {
        /Met\.? Encore: (.*)/ => 'Met Opera:',
        /Met\.? Opera: (.*)/  => 'Met Opera: ',
        /NT Encore: (.*)/     => 'National Theatre:',
        /NT Live: (.*)/       => 'National Theatre:',
        /ROH\.? Live: (.*)/   => 'Royal Opera House:',
        /RSC\.? Live: (.*)/   => 'Royal Shakespeare Company:',
        /RSC\.? Encore: (.*)/ => 'Royal Shakespeare Company:'
      }

      # @param [String] title a film title
      def initialize(title)
        @title = title
      end

      # sanitized and standardized title
      # @return [String] title
      def sanitized
        @sanitzed ||= begin
          sanitized = @title
          REMOVE.each do |pattern|
            sanitized.gsub! pattern, ''
          end
          REPLACE.each do |pattern, prefix|
            sanitized.gsub!(pattern) { |_| prefix + $1 }
          end
          sanitized.squeeze(' ').strip
        end
      end
    end
  end
end
