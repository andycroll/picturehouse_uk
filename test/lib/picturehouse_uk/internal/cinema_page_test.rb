require_relative '../../../test_helper'

describe PicturehouseUk::Internal::CinemaPage do
  let(:described_class) { PicturehouseUk::Internal::CinemaPage }

  let(:website) { Minitest::Mock.new }

  before do
    WebMock.disable_net_connect!
  end

  describe '#film_html' do
    subject { described_class.new('Duke_of_Yorks').film_html }

    before do
      website.expect(:cinema, dukes_html, ['Duke_of_Yorks'])
    end

    it 'returns an non-zero array of film screenings html fragments' do
      PicturehouseUk::Internal::Website.stub :new, website do
        subject.must_be_instance_of(Array)
        subject.size.must_be :>, 0

        subject.each do |film_html|
          film_html.must_be_instance_of(String)
          film_html.size.must_be :>, 0
        end
      end
    end

    it 'returns an array with correct content' do
      PicturehouseUk::Internal::Website.stub :new, website do
        subject[1..-1].each do |html|
          html.must_include('class="imageborder"') # poster
          html.must_include('class="movielink"')   # title
          html.must_include('epoch="')             # screening
        end
      end
    end
  end

  private

  def read_file(filepath)
    File.read(File.expand_path(filepath, __FILE__))
  end

  def dukes_html
    read_file('../../../../fixtures/cinema/Duke_of_Yorks.html')
  end
end
