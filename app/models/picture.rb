class Picture < ActiveRecord::Base
  belongs_to :gallery

  has_attached_file :image, styles: {medium: '500x500>', thumb: '100x100>'}

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
