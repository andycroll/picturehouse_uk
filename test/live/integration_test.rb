require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new(color: true)
]

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

describe PicturehouseUk::Performance do
  let(:described_class) { PicturehouseUk::Performance }

  describe '.at(cinema_id)' do
    subject { described_class.at('Duke_Of_Yorks') }

    it 'returns an array of screenings' do
      subject.must_be_instance_of(Array)
      subject.each do |performance|
        performance.must_be_instance_of(PicturehouseUk::Performance)
      end
    end

    it 'returns correct number of screenings' do
      subject.count.must_be :>, 10
    end
  end
end
