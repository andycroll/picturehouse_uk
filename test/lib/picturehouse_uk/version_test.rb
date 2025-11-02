require_relative '../../test_helper'

class PicturehouseUkTest < Minitest::Test
  def test_version_must_be_defined
    refute_nil PicturehouseUk::VERSION
  end
end
