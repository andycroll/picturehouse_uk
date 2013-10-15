require_relative '../../../test_helper'

describe PicturehouseUk::Internal::FilmWithScreeningsParser do

  describe '#film_name' do
    subject { PicturehouseUk::Internal::FilmWithScreeningsParser.new(film_html).film_name }
  end

  def read_film_html(filename, cinema='brighton')
    path = "../../../../fixtures/#{cinema}-showtimes"
    File.read(File.expand_path("#{path}/#{filename}.html", __FILE__))
  end
end
