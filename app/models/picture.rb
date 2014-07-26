class Picture < ActiveRecord::Base
  belongs_to :gallery

  has_attached_file :image,
    styles: {medium: '550x550>', thumb: '200x200>'},
    url: '/system/:hash.:extension',
    hash_secret: Rails.application.secrets[:secret_key_base]

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  after_image_post_process :set_photographed_at


  private

  def set_photographed_at
    exif = nil

    begin
      exif = EXIFR::JPEG.new(image.queued_for_write[:original].path)
    rescue EXIFR::MalformedJPEG
    end

    if exif && exif.exif?
      self.photographed_at = exif.date_time_digitized
    end
  end
end
