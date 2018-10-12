require 'test_helper'

class PicturesIntegrationTest < ActionDispatch::IntegrationTest
  describe 'capybara', js: true do
    let(:gallery) { Gallery.create! }
    subject do
      pic = gallery.pictures.build
      pic.image_file.attach(io: emsi(), filename: 'emsi.png')
      pic.save!
      pic
    end

    it 'downloads' do
      visit(gallery_picture_path(subject.gallery, subject.image_fingerprint))

      page.find('button.dropdown-toggle').click
      click_link('Download')

      page.response_headers['Content-Disposition']
         .must_equal('attachment; filename="emsi.png"; filename*=UTF-8\'\'emsi.png')

      # p page.source
      # page.source.force_encoding('utf-8').must_equal(EMSI.read)
    end
  end
end
