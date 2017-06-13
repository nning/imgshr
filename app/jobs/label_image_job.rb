class LabelImageJob < ApplicationJob
  queue_as :label_image

  def perform(picture)
    result = LabelImage::Process.new(picture.image.path(:medium)).run

    labels = []
    result.each do |label, score|
      labels.push(label) if score >= 0.25
    end

    picture.label_list = labels
    picture.save!
  end
end
