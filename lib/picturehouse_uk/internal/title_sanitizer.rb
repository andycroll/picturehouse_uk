module PicturehouseUk
  # @api private
  module Internal
    # Sanitize and standardize film titles
    class TitleSanitizer
      # strings and regex to be removed
      REMOVE = [
        /\s\[(AS LIVE:\s*)?[ACPGU1258]+\]/, # regular certificate
        /\s+[23][dD]/,                      # 2d or 3d from title
        /\s\[NO CERT\]/,                    # no certificate
        /\s\[\]/,                           # blank certificate
        /ourscreen\: /,                     # ourscreen
        /\s\(Re(\: \d{0,4})?\)/i,           # Re-release
        /\s\[CERT TBC\]/,                   # certificate TBC
        /\s?\-\s?autism.*ing\s?/i,          # austim screening
        /\s?\+\s?Q\&A\.?/i,                 # +Q&A
        /KIDS CLUB\s*/i,                    # kids club
        /DISCOVER TUE\s*/i,                 # discover tue
      ]

      # regexes and their replacements
      REPLACE = {
        /Met\.? Encore:\s*(.*)/ => 'Met Opera:',
        /Met\.? Opera:\s*(.*)/  => 'Met Opera: ',
        /NT Encore:\s*(.*)/     => 'National Theatre:',
        /NT Live:\s*(.*)/       => 'National Theatre:',
        /ROH\.? Live:\s*(.*)/   => 'Royal Opera House:',
        /RSC\.? Live:\s*(.*)/   => 'Royal Shakespeare Company:',
        /RSC\.? Encore:\s*(.*)/ => 'Royal Shakespeare Company:'
      }

      # @param [String] title a film title
      def initialize(title)
        @title = title
      end

      # sanitized and standardized title
      # @return [String] title
      def sanitized
        @sanitzed ||= begin
          sanitized = @title.gsub('&amp;', '&')
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
