class GalleryTest < ActiveSupport::TestCase
  describe 'slug' do
    subject { Gallery.new.slug }

    it 'should not be nil' do
      subject.wont_be_nil
    end

    it 'length should equal configured token length' do
      subject.size.must_equal RandomString::TOKEN_LENGTH
    end
  end
end
