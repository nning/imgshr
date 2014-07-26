class Picture < ActiveRecord::Base
  belongs_to :gallery

  has_attached_file :image,
    styles: {medium: '550x550>', thumb: '200x200>'},
    url: '/system/:hash.:extension',
    hash_secret: Rails.application.secrets[:secret_key_base]

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
