require_relative '../../../../test_helper'

describe PicturehouseUk::Internal::Parser::Screenings do
  let(:described_class) { PicturehouseUk::Internal::Parser::Screenings }

  let(:website) { Minitest::Mock.new }

  before do
    WebMock.disable_net_connect!
  end

  %w(Duke_Of_Yorks Dukes_At_Komedia Phoenix_Picturehouse).each do |cinema|
    describe "#{cinema}: #to_a" do
      subject { described_class.new(cinema).to_a }

      before { website.expect(:whats_on, html(cinema), [cinema]) }

      it 'returns an non-zero array of hashes' do
        PicturehouseUk::Internal::Website.stub :new, website do
          subject.must_be_instance_of(Array)
          subject.size.must_be :>, 0

          subject.each do |element|
            element.must_be_instance_of(Hash)
            element.keys.must_equal([:film_name, :dimension, :variant, :booking_url, :time])
            element[:film_name].must_be_kind_of(String)
            element[:dimension].must_match(/\A[23]d\z/)
            if element[:booking_url]
              element[:booking_url].must_match(/\Ahttps?\:\/\//)
              element[:booking_url].must_match(/ticketing/)
              element[:booking_url].must_match(/visSelectTickets\.aspx\?cinemacode=\d+\&txtSessionId=\d+/)
            end
            element[:time].must_be_kind_of(Time)
          end

          variants = subject.flat_map { |e| e[:variant] }.uniq
          %w(arts baby senior).each do |expected| # also kids
            variants.must_include(expected)
          end
        end
      end
    end
  end

  %w(National_Media_Museum).each do |cinema|
    describe "#{cinema}: #to_a" do
      subject { described_class.new(cinema).to_a }

      before { website.expect(:whats_on, html(cinema), [cinema]) }

      it 'returns an non-zero array of hashes with imax variants' do
        PicturehouseUk::Internal::Website.stub :new, website do
          subject.must_be_instance_of(Array)
          subject.size.must_be :>, 0

          variants = subject.flat_map { |e| e[:variant] }.uniq
          variants.must_include('imax')
        end
      end
    end
  end

  private

  def read_file(filepath)
    File.read(File.expand_path(filepath, __FILE__))
  end

  def html(cinema)
    read_file("../../../../../fixtures/whats_on/#{cinema}.html")
  end
end
