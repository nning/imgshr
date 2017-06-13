class LabelImageJob < ApplicationJob
  queue_as :label_image

  def perform(picture)
    process = LabelImage::Process.new(picture.image.path(:medium))

    process.run

    picture.label_list = process.labels_above_threshold
    picture.save!
  end
end
