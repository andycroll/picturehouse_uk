require 'minitest/autorun'
require 'minitest/reporters'
reporter_options = { color: true, slow_count: 5 }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

require File.expand_path('../../../lib/picturehouse_uk.rb', __FILE__)

describe PicturehouseUk::Cinema do
  let(:described_class) { PicturehouseUk::Cinema }

  describe '.all' do
    subject { described_class.all }

    it 'returns an Array of CineworldUK::Cinemas' do
      subject.must_be_instance_of(Array)
      subject.each do |value|
        value.must_be_instance_of(PicturehouseUk::Cinema)
      end
    end

    it 'returns the correctly sized array' do
      subject.size.must_be :>, 18
    end

    it 'returns the right cinemas' do
      subject.first.name.must_equal 'Clapham Picturehouse'
      subject.last.name.must_equal 'City Screen Picturehouse'
    end
  end
end

describe PicturehouseUk::Film do
  let(:described_class) { PicturehouseUk::Film }

  describe '.at(cinema_id)' do
    subject { described_class.at('Duke_Of_Yorks') }

    it 'returns an array of films' do
      subject.must_be_instance_of(Array)
      subject.each do |film|
        film.must_be_instance_of(PicturehouseUk::Film)
      end
    end

    it 'returns a decent number of films' do
      subject.count.must_be :>, 5
    end
  end
end

describe PicturehouseUk::Screening do
  let(:described_class) { PicturehouseUk::Screening }

  describe '.at(cinema_id)' do
    subject { described_class.at('Duke_Of_Yorks') }

    it 'returns an array of screenings' do
      subject.must_be_instance_of(Array)
      subject.each do |screening|
        screening.must_be_instance_of(PicturehouseUk::Screening)
      end
    end

    it 'returns correct number of screenings' do
      subject.count.must_be :>, 10
    end
  end
end
