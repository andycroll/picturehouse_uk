require_relative '../../test_helper'

describe PicturehouseUk::Film do
  let(:described_class) { PicturehouseUk::Film }

  describe '.new(name)' do
    it 'stores name' do
      film = described_class.new('Iron Man 3')
      film.name.must_equal 'Iron Man 3'
    end
  end

  describe '.at(cinema_id)' do
    let(:website) { Minitest::Mock.new }

    subject { described_class.at('Duke_Of_Yorks') }

    before do
      website.expect(:cinema, cinema_html('Duke_Of_Yorks'), ['Duke_Of_Yorks'])
    end

    it 'returns an array of films' do
      PicturehouseUk::Internal::Website.stub :new, website do
        subject.must_be_instance_of(Array)
        subject.each do |film|
          film.must_be_instance_of(PicturehouseUk::Film)
        end
      end
    end

    it 'returns a decent number of films' do
      PicturehouseUk::Internal::Website.stub :new, website do
        subject.count.must_be :>, 5
      end
    end

    it 'returns uniquely named films' do
      PicturehouseUk::Internal::Website.stub :new, website do
        subject.each_with_index do |item, index|
          subject.each_with_index do |jtem, i|
            next if index == i
            item.name.wont_equal jtem.name
            item.wont_equal jtem
          end
        end
      end
    end
  end

  describe 'Comparable' do
    it 'includes comparable methods' do
      film = described_class.new 'AAAA'
      film.methods.must_include :<
      film.methods.must_include :>
      film.methods.must_include :==
      film.methods.must_include :<=>
      film.methods.must_include :<=
      film.methods.must_include :>=
    end

    describe 'uniqueness' do
      it 'defines #hash' do
        film = described_class.new 'AAAA'
        film.methods.must_include :hash
      end

      describe '#hash' do
        it 'returns a hash of the slug' do
          film = described_class.new 'AAAA'
          film.hash == film.slug.hash
        end
      end

      it 'defines #eql?(other)' do
        film = described_class.new 'AAAA'
        film.methods.must_include :eql?
      end

      describe 'two identically named films' do
        let(:film)      { described_class.new 'AAAA' }
        let(:otherfilm) { described_class.new 'AAAA' }

        it 'retuns only one' do
          result = [film, otherfilm].uniq
          result.count.must_equal 1
          result.must_equal [ described_class.new('AAAA') ]
        end
      end
    end

    describe '<=> (other)' do
      subject { film <=> otherfilm }

      describe 'film less than other' do
        let(:film)      { described_class.new 'AAAA' }
        let(:otherfilm) { described_class.new 'BBBB' }

        it 'retuns -1' do
          subject.must_equal -1
        end
      end

      describe 'film greater than other' do
        let(:film)      { described_class.new 'CCCC' }
        let(:otherfilm) { described_class.new 'BBBB' }

        it 'retuns 1' do
          subject.must_equal 1
        end
      end

      describe 'film same as other (exact name)' do
        let(:film)      { described_class.new 'AAAA' }
        let(:otherfilm) { described_class.new 'AAAA' }

        it 'retuns 0' do
          subject.must_equal 0
        end
      end

      describe 'film same as other (inexact name)' do
        let(:film)      { described_class.new 'blue jasmine' }
        let(:otherfilm) { described_class.new 'Blue Jasmine' }

        it 'retuns 0' do
          subject.must_equal 0
        end
      end
    end
  end

  private

  def cinema_html(filename)
    read_file("../../../fixtures/cinema/#{filename}.html")
  end

  def read_file(filepath)
    File.read(File.expand_path(filepath, __FILE__))
  end
end
