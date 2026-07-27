class ImageResizeJob < ApplicationJob
  queue_as :active_storage_resize

  # Stale jobs from before a DB reset reference Picture IDs that no longer exist.
  # ActiveJob raises ActiveJob::DeserializationError (wrapping RecordNotFound) at
  # argument-deserialization time, before #perform is called. Discard those silently.
  discard_on ActiveJob::DeserializationError

  def perform(picture)
    return unless picture.plain?

    picture.preprocess_variants!
  end
end
