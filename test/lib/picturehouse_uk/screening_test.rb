require_relative '../../test_helper'

describe PicturehouseUk::Screening do

  before { WebMock.disable_net_connect! }

  describe '#new film_name, cinema_name, date, time, varient' do
    it 'stores film_name, cinema_name & when (in UTC)' do
      screening = PicturehouseUk::Screening.new 'Iron Man 3', "Duke's At Komedia", '2013-09-12', '11:00'
      screening.film_name.must_equal 'Iron Man 3'
      screening.cinema_name.must_equal "Duke's At Komedia"
      screening.when.must_equal Time.utc(2013, 9, 12, 11, 0)
      screening.varient.must_equal nil
    end

    it 'stores varient if passed' do
      screening = PicturehouseUk::Screening.new 'Iron Man 3', "Duke's At Komedia", '2013-09-12', '11:00', 'baby'
      screening.film_name.must_equal 'Iron Man 3'
      screening.cinema_name.must_equal "Duke's At Komedia"
      screening.when.must_equal Time.utc(2013, 9, 12, 11, 0)
      screening.varient.must_equal 'baby'
    end
  end

  describe '#date' do
    subject { PicturehouseUk::Screening.new('Iron Man 3', "Duke's At Komedia", '2013-09-12', '11:30', '3d').date }
    it 'should return date of showing' do
      subject.must_be_instance_of(Date)
      subject.must_equal Date.new(2013, 9, 12)
    end
  end
end
