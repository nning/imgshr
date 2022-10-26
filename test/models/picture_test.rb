require_relative '../test_helper'

class PictureTest < ActiveSupport::TestCase
  let(:gallery) { Gallery.create! }

  describe 'image' do
    subject { gallery.pictures.build }

    it 'should attach image' do
      subject.image_file.attach(io: emsi(), filename: 'emsi.png')
      subject.save!
      _(subject.image_file).wont_be_nil
    end
  end

  describe 'image analyzer' do
    let(:picture) do
      pic = gallery.pictures.build
      pic.image_file.attach(io: avenger(), filename: 'avenger.jpg')
      pic.save!
      pic
    end

    subject { ImageExifAnalyzer.new(picture.image_file.blob) }

    it 'should return metadata' do
      _(subject.metadata).must_equal({
        width: 2000,
        height: 1331,
        camera: 'NIKON CORPORATION NIKON D700',
        photographed_at: Time.parse('2011-09-03 12:45:30 +0200'),
        aperture: 9.0,
        shutter_speed: Rational(1, 799),
        iso_speed: 200,
        flash: 0,
        focal_length: 210.0,
        software: 'Adobe Photoshop CS3 Windows',
        hdr: false
      })
    end
  end
end
