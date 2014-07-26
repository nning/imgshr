class Gallery < ActiveRecord::Base
  after_initialize do
    if new_record?
      self.slug ||= Base64.encode64(UUIDTools::UUID.random_create)[0..5]
    end
  end
end
