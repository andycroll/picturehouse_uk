require_relative '../../test_helper'

describe PicturehouseUk do
  it 'must be defined' do
    _(PicturehouseUk::VERSION).wont_be_nil
  end
end
