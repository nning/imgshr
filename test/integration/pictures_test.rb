require 'test_helper'

class PicturesIntegrationTest < ActionDispatch::IntegrationTest
  describe 'pictures' do
    let(:gallery) { Gallery.create! }
    subject do
      pic = gallery.pictures.build
      pic.image_file.attach(io: emsi, filename: 'emsi.png')
      pic.save!
      pic
    end

    it 'returns original image' do
      visit(gallery_picture_path(subject.gallery, subject))
      visit(page.find('.image a')[:href])

      page.response_headers['Content-Type']
        .must_equal('image/png')
    end

    it 'returns image variant' do
      visit(gallery_picture_path(subject.gallery, subject))
      visit(page.find('noscript img')[:src])

      page.response_headers['Content-Type']
        .must_equal('image/png')
    end

    it 'downloads' do
      visit(gallery_picture_path(subject.gallery, subject))

      page.find('button.dropdown-toggle').click
      click_link('Download')

      page.response_headers['Content-Disposition']
        .must_equal('attachment; filename="emsi.png"; filename*=UTF-8\'\'emsi.png')

      page.source.force_encoding('utf-8')
        .must_equal(emsi.read)
    end
  end
end
