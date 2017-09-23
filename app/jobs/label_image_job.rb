class LabelImageJob < ApplicationJob
  queue_as :label_image

  def perform(picture)
    picture.label_image!
  end
end
