class BossToken < ActiveRecord::Base
  belongs_to :gallery, dependent: :destroy
  has_many :pictures, through: :gallery

  after_initialize do
    if new_record?
      self.slug ||= Base64.encode64(UUIDTools::UUID.random_create)[0..7]
    end
  end

  def to_param
    slug
  end

  def to_s
    slug
  end
end
