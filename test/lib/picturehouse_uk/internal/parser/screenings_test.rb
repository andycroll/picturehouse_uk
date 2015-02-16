require_relative '../../../../test_helper'

describe PicturehouseUk::Internal::Parser::Screenings do
  let(:described_class) { PicturehouseUk::Internal::Parser::Screenings }

  let(:website) { Minitest::Mock.new }

  before do
    WebMock.disable_net_connect!
  end

  %w(Duke_Of_Yorks Dukes_At_Komedia Pheonix_Oxford) do |cinema|
    describe '#to_a' do
      subject { described_class.new(cinema).to_a }

      before { website.expect(:cinema, html(cinema), [cinema]) }

      it 'returns an non-zero array of hashes' do
        PicturehouseUk::Internal::Website.stub :new, website do
          subject.must_be_instance_of(Array)
          subject.size.must_be :>, 0

          subject.each do |element|
            element.must_be_instance_of(Hash)
            element.keys.must_equal([:film_name, :dimension, :variant, :booking_url, :time])
            element[:film_name].must_be_kind_of(String)
            element[:dimension].must_match(/\A[23]d\z/)
            element[:booking_url].must_match(/\Ahttps?\:\/\//)
            element[:time].must_be_kind_of(Time)
          end
        end
      end
    end
  end

  private

  def read_file(filepath)
    File.read(File.expand_path(filepath, __FILE__))
  end

  def html(cinema)
    read_file("../../../../../fixtures/cinema/#{cinema}.html")
  end
end