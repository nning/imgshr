class Gallery < ActiveRecord::Base
  has_many :pictures, dependent: :destroy

  after_initialize do
    if new_record?
      self.slug ||= Base64.encode64(UUIDTools::UUID.random_create)[0..7]
    end
  end

  def last_update
    pictures.order('created_at desc').limit(1).first.updated_at
  rescue NoMethodError
    updated_at
  end

  def to_param
    slug
  end

  def to_s
    name? ? name : slug
  end
end
