require 'test_helper'

class ContentTest < ActiveSupport::TestCase

  test 'create contents without temp' do
    value = 'Created!'
    contents = create_contents(value)
    assert contents.save
    assert contents.value, value
  end

  test 'create contents with temp' do
    image, filename, content_type = create_image
    contents = create_contents
    contents.save

    contents.images.attach(io: image, filename: filename, content_type: content_type)
    assert contents.images.attached?
  end

  test 'compare temp image and contents image' do
    temp, contents = create_temp_and_contents
    temp_image = temp.image

    contents.images.attach(temp_image.blob)
    assert contents.images.attached?

    content_image = contents.images.first

    assert_not_equal content_image, temp_image
    assert_equal content_image.blob, temp_image.blob
    assert_equal url_for(content_image), url_for(temp_image)
  end

  def create_contents(value = '')
    Content.new(value: value)
  end

  def create_temp_and_contents
    temp = create_temp_with_image

    contents = create_contents
    contents.save

    return temp, contents
  end
end
