require 'test_helper'

class PicturesControllerTest < ActionController::TestCase
  EMSI = open(Rails.root.join('public/images/emsi.png'))

  describe :picture do
    let(:gallery) { Gallery.create!}
    subject { gallery.pictures.create!(image: EMSI) }

    it 'update title' do
      put :update, params: { slug: gallery , id: subject, picture: { title: 'foo' } }, xhr: true
      response.must_be :successful?
      Picture.last.title.must_equal 'foo'
    end

    it 'update tag_list' do
      put :update, params: { slug: gallery , id: subject, picture: { tag_list: 'foo, bar' } }, xhr: true
      response.must_be :successful?
      Picture.last.tag_list.must_equal ['foo', 'bar']
    end
  end
end
