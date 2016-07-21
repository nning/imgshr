require 'test_helper'

class GalleriesIntegrationTest < ActionDispatch::IntegrationTest
  describe 'capybara', js: true do
    before do
      @gallery = Gallery.create!
      @file = File.open(Rails.root.join('public', 'images', 'emsi.png'))
    end

    subject { @gallery.pictures.create!(image: @file) }

    it 'downloads' do
      visit(gallery_picture_path(subject.gallery, subject.image.fingerprint))

      page.find('button.dropdown-toggle').click
      click_link('Download')

      page.response_headers['Content-Disposition']
        .must_equal('attachment; filename="emsi.png"')

      page.source.force_encoding('utf-8').must_equal(@file.read)
    end
  end
end
