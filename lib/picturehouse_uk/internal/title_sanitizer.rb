module PicturehouseUk
  # @api private
  module Internal
    # Sanitize and standardize film titles
    class TitleSanitizer < Cinebase::TitleSanitizer
      # @!method initialize(title)
      #   Constructor
      #   @param [String] title a film title
      #   @return [CineworldUk::Internal::TitleSanitizer]

      # @!method sanitized
      #   sanitized and standardized title
      #   @return [String] sanitised title

      private

      # strings and regex to be removed
      def remove
        [
          /\s\[(AS LIVE:\s*)?[ACPGU1258]+\]/, # regular certificate
          /\s\[R18\]/,                        # R18
          /\s+\(?[23][dD]\)?/,                # 2d or 3d from title
          /\bIMAX\b/i,                        # imax from title
          /\s\[NO CERT\]/,                    # no certificate
          /\s\[TBC\]/,                        # tbc
          /\s\[N\/A\]/i,                      # n/a
          /\s\(Theatre\)/i,                   # (theatre)
          /\s\[\]/,                           # blank certificate
          /ourscreen\: /,                     # ourscreen
          /\s\(Re(\: \d{0,4})?\)/i,           # Re-release
          /\s\[CERT TBC\]/,                   # certificate TBC
          /\s?\-\s?autism.*ing\s?/i,          # austim screening
          /\s?\+\s?Q\&(amp;)*A\.?/i,          # +Q&A
          /KIDS CLUB\s*/i,                    # kids club
          /DISCOVER TUE(sday\:)*\s*/i,        # discover tue
          /FREE Screening\s*-\s*/i,           # free screening
          /\s*-?\s*Big Scream\s*-?\s*/i,      # big scream
          /\*?HOH Subtitled\*?/i,             # subtitled
          /\s*\-?\s*Reminiscence/i,           # reminiscence
          /\s*\-?\s*\(?Re\-issue\)?/i,        # reissue
          /\s*-?\s*Kids\'? Club\s*-?\s*/,     # kids club
          /\s*plus Q\&A.*/i,                  # extended Q&A
          /Cinemania\s*[\:\-]/i,              # cinemania
          /\@\s*komedia/i,                    # @ komedia
          /\s*\+ panel.*/i,                   # panel
          /toddler time\s*\:*\-*/i,           # toddler time
          /\(.*\d{4}\)/,                      # year or captured year
          /\bsingalong\b/i,                   # singalong
          /\s+\-?\s*Parents \& Babies/i,      # parents and babies
          /Subtitled\:*\s*/i,                 # subtitled
          /\(?live\)?\z/i,                    # live
          /amp\;/i
        ]
      end

      # regexes and their replacements
      def replace
        {
          /Met\.? Encore:\s*(.*)/    => 'Met Opera: ',
          /Met\.? Opera:\s*(.*)/     => 'Met Opera: ',
          /National Theatre:\s*(.*)/ => 'NT Live: ',
          /NT Encore:\s*(.*)/        => 'NT Live: ',
          /NT Live:\s*(.*)/          => 'NT Live: ',
          /ROH\.? Live:\s*(.*)/      => 'Royal Opera House: ',
          /ROH\.? Encore:\s*(.*)/    => 'Royal Opera House: ',
          /RSC\.? Live:\s*(.*)/      => 'Royal Shakespeare Company: ',
          /RSC\.? Encore:\s*(.*)/    => 'Royal Shakespeare Company: ',
          /(.*) \(Bolshoi Ballet\)/  => 'Bolshoi Ballet: '
        }
      end
    end
  end
end
