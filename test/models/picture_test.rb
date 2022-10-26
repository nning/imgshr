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

    it 'should attach same image in 2 galleries' do
      subject.image_file.attach(io: emsi(), filename: 'emsi.png')
      subject.save!
      _(subject.image_file).wont_be_nil

      another_picture = Gallery.create!.pictures.build
      another_picture.image_file.attach(io: emsi(), filename: 'emsi.png')
      another_picture.save!
      _(another_picture.image_file).wont_be_nil

      _(Picture.count).must_equal(2)
    end

    it 'should not attach same image in 1 gallery' do
      subject.image_file.attach(io: emsi(), filename: 'emsi.png')
      subject.save!
      _(subject.image_file).wont_be_nil

      another_picture = gallery.pictures.build
      another_picture.image_file.attach(io: emsi(), filename: 'emsi.png')
      _(another_picture.validate).must_equal(false)

      begin
        another_picture.save!
      rescue
      end
      _(gallery.pictures.count).must_equal(1)
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
