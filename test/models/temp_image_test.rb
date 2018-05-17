require 'test_helper'

class TempImageTest < ActiveSupport::TestCase
  
  test 'create temp with image' do
    temp = create_temp_with_image
    assert temp.image.attached?
  end

end
