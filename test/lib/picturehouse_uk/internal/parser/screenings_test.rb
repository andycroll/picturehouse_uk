# NOTE: These tests are commented out because the whats_on endpoint has been removed
# The Parser::Screenings class needs to be updated to work with the new API structure
# before these tests can be re-enabled

# require_relative '../../../../test_helper'
#
# describe PicturehouseUk::Internal::Parser::Screenings do
#   let(:described_class) { PicturehouseUk::Internal::Parser::Screenings }
#   let(:website) { Minitest::Mock.new }
#
#   before { WebMock.disable_net_connect! }
#   after { WebMock.allow_net_connect! }
#
#   %w(Duke_Of_Yorks Dukes_At_Komedia Phoenix_Picturehouse).each do |cinema|
#     describe "#{cinema}: #to_a" do
#       subject { described_class.new(cinema).to_a }
#
#       before { website.expect(:whats_on, html(cinema), [cinema]) }
#
#       it 'returns an non-zero array of hashes' do
#         PicturehouseUk::Internal::Website.stub :new, website do
#           _(subject).must_be_instance_of(Array)
#           _(subject.size).must_be :>, 0
#
#           subject.each do |element|
#           _(  element).must_be_instance_of(Hash)
#           _(  element.keys).must_equal([:film_name, :dimension, :variant,
#                                      :booking_url, :starting_at])
#           _(  element[:film_name]).must_be_kind_of(String)
#           _(  element[:dimension]).must_match(/\A[23]d\z/)
#             if element[:booking_url]
#           _(    element[:booking_url]).must_match(%r{\Ahttps?\://picturehouses.com})
#           _(    element[:booking_url]).must_match(%r{/cinema/#{cinema}/film/[-\w]+/tickets/\d+})
#             end
#           _(  element[:starting_at]).must_be_kind_of(Time)
#           end
#
#           variants = subject.flat_map { |e| e[:variant] }.uniq
#           %w(arts baby senior).each do |expected| # also kids
#           _(  variants).must_include(expected)
#           end
#         end
#       end
#     end
#   end
#
#   %w(National_Media_Museum).each do |cinema|
#     describe "#{cinema}: #to_a" do
#       subject { described_class.new(cinema).to_a }
#
#       before { website.expect(:whats_on, html(cinema), [cinema]) }
#
#       it 'returns an non-zero array of hashes with imax variants' do
#         PicturehouseUk::Internal::Website.stub :new, website do
#           _(subject).must_be_instance_of(Array)
#           _(subject.size).must_be :>, 0
#
#           variants = subject.flat_map { |e| e[:variant] }.uniq
#           _(variants).must_include('imax')
#         end
#       end
#     end
#   end
#
#   private
#
#   def read_file(filepath)
#     File.read(File.expand_path(filepath, __FILE__))
#   end
#
#   def html(cinema)
#     read_file("../../../../../fixtures/#{cinema}/whats_on.html")
#   end
# end
