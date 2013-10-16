module PicturehouseUk
  module Internal
    # Private: An object to parse a film HTML snippet
    class FilmWithScreeningsParser

      def initialize(film_html)
        @nokogiri_html = Nokogiri::HTML(film_html)
      end

      def film_name
        name = @nokogiri_html.css('.movielink').children.first.to_s

        # screening types
        name = name.gsub /\s\[[ACPGU1258]+\]/, '' # remove certificate
        name = name.gsub /\s+[23][dD]/, '' # remove 2d or 3d from title
      end

      def showings
        tz = TZInfo::Timezone.get('Europe/London')
        out = @nokogiri_html.css('a[epoch]').inject({}) do |result, link|
          key = case link['class']
            when /big_scream/ then 'baby'
            when /kids_club|toddler_time/ then 'kids'
            when /silver_screen/ then 'silver'
            when /subtitled_cinema/ then 'subtitled'
            else '2d'
          end
          time = Time.at(link['epoch'].to_i)

          result.merge(key => (result[key] || []) << tz.local_to_utc(time))

      #     varient = varient_node.css('.tech a').text.gsub('in ', '').upcase

      #     times = varient_node.css('.performance-detail').map do |screening_node|
      #       tz.local_to_utc(Time.parse(screening_node['title'].match(/\d+\/\d+\/\d+ \d{2}\:\d{2}/).to_s))
      #     end

      #     result.merge(varient => times)
        end
        pp out
      end
    end
  end
end
