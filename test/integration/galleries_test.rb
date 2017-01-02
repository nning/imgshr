require 'test_helper'

class GalleriesIntegrationTest < ActionDispatch::IntegrationTest
  it 'creation' do
    post galleries_url
    response.must_be :redirect?
    slug = slug_redirected_to

    get gallery_url(slug)
    response.must_be :success?

    # post gallery_picture_url(slug)
    # response.must_be :success?
  end

  describe 'capybara', js: true do
    subject { Gallery.create! }

    it 'uploads' do
      visit(gallery_path(subject))
      click_link('Upload')
      attach_file('picture_image', Rails.root.join('public', 'images', 'emsi.png'))
      click_button('Upload!')
      page.must_have_content('Picture count 1')
      subject.pictures.count.must_equal(1)
    end
  end

  describe 'device links' do
    subject { Gallery.create! }
    let(:slug) { subject.slug }

    it :device_links_only do
      subject.update_attributes!(device_links_only: true)

      get gallery_url(slug)
      response.status.must_equal 404

      post gallery_create_device_link_url(slug), xhr: true
      response.must_be :success?

      get device_link_path(subject.device_links.first.slug)
      response.must_be :redirect?

      get gallery_url(slug)
      response.status.must_equal 200
    end
  end

  private

  def slug_redirected_to
    response.get_header('Location').split('!')[1]
  end
end
