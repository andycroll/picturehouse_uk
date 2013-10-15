require_relative '../../test_helper'

describe PicturehouseUk::Film do
  describe '.new(name)' do
    it 'stores name' do
      film = PicturehouseUk::Film.new 'Iron Man 3'
      film.name.must_equal 'Iron Man 3'
    end
  end
end
