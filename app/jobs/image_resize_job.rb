class ImageResizeJob < ApplicationJob
  queue_as :active_storage_resize

  def perform(picture)
    picture.preprocess_variants!
  end
end
