class Gallery < ActiveRecord::Base
  has_many :pictures

  after_initialize do
    if new_record?
      self.slug ||= Base64.encode64(UUIDTools::UUID.random_create)[0..7]
    end
  end
end
