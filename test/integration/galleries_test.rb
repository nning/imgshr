require 'test_helper'

class GalleriesIntegrationTest < ActionDispatch::IntegrationTest
  it 'creation and upload' do
    post galleries_url
    response.must_be :redirect?
    slug = slug_redirected_to

    get gallery_url(slug)
    response.must_be :success?

    # post gallery_picture_url(slug)
    # response.must_be :success?
  end

  private

  def slug_redirected_to
    response.get_header('Location').split('!')[1]
  end
end
