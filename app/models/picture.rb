class Picture < ActiveRecord::Base
  belongs_to :gallery

  has_attached_file :image, styles: {medium: '600x600>', thumb: '200x200>'}

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
