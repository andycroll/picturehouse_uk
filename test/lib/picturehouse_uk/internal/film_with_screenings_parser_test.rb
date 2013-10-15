require_relative '../../../test_helper'

describe PicturehouseUk::Internal::FilmWithScreeningsParser do

  describe '#showings' do
    subject { PicturehouseUk::Internal::FilmWithScreeningsParser.new(film_html).showings }

    describe 'multiple screenings' do
      let(:film_html) { read_film_html 'blue-jasmine-future'}

      it 'returns a hash keyed by type of performance' do
        subject.must_be_instance_of Hash
        subject.keys.each { |key| key.must_be_instance_of String }
      end

      it 'returns an array of Times for each type of performance' do
        subject.each do |key, value|
          value.must_be_instance_of Array
          value.each do |item|
            item.must_be_instance_of Time
          end
        end
      end

      it 'returns the correct number of Times' do
        subject.keys.must_equal ['2d']
        subject['2d'].count.must_equal 2
      end

      it 'returns Times in UTC' do
        subject['2d'].first.must_equal Time.utc(2013, 10, 15, 9, 30, 0)
        subject['2d'].last.must_equal Time.utc(2013, 10, 15, 20, 15, 0)
      end
    end

    describe 'screenings including OAP & subtitled' do
      let(:film_html) { read_film_html 'captain-phillips-with-silver-screen-and-subtitles'}

      it 'returns an array of Times for each type of performance' do
        subject.each do |key, value|
          value.must_be_instance_of Array
          value.each do |item|
            item.must_be_instance_of Time
          end
        end
      end

      it 'returns the correct number of Times' do
        subject.keys.sort.must_equal ['2d', 'silver', 'subtitled']

        subject['2d'].count.must_equal 1
        subject['silver'].count.must_equal 2
        subject['subtitled'].count.must_equal 1
      end
    end

    describe 'screenings including toddler time' do
      let(:film_html) { read_film_html 'london-film-festival-with-toddler-time'}

      it 'returns the correct number of Times' do
        subject.keys.must_equal ['kids']
        subject['kids'].count.must_equal 1
      end
    end

    describe 'screenings including baby' do
      let(:film_html) { read_film_html 'fifth-estate-with-big-scream'}

      it 'returns the correct number of Times' do
        subject.keys.sort.must_equal ['2d', 'baby']

        subject['2d'].count.must_equal 4
        subject['baby'].count.must_equal 1
      end
    end

    describe 'screenings including kids' do
      let(:film_html) { read_film_html 'planes-with-kids-club'}

      it 'returns the correct number of Times' do
        subject.keys.must_equal ['kids']
        subject['kids'].count.must_equal 1
      end
    end

    describe 'expired screenings' do
      let(:film_html) { read_film_html 'blue-jasmine-done'}

      it 'returns an empty hash' do
        subject.must_be_instance_of Hash
        subject.must_be_empty
      end
    end
  end

  def read_film_html(filename)
    path = "../../../../fixtures/film_node"
    File.read(File.expand_path("#{path}/#{filename}.html", __FILE__))
  end
end
