ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  include Rails.application.routes.url_helpers

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  default_url_options[:host] = :localhost

  # Add more helper methods to be used by all tests here...
  def create_temp_with_image
    image, filename, content_type = create_image
    temp = TempImage.new
    temp.transaction do
      temp.image.attach(io: image, filename: filename, content_type: content_type) if temp.save
    end
    temp
  end

  def create_image
    image = File.open("#{Rails.root}/public/images/test.jpeg")
    filename = File.basename(image)
    content_type = 'image/jpeg'

    return image, filename, content_type
  end
end
