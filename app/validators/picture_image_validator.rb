class PictureImageValidator < ActiveModel::Validator
  def validate(record)
    unless record.image_file.attached?
      record.errors[:base] << 'Image missing'
      return
    end

    return unless record.plain?

    content_type = record.image_file.blob.content_type

    if !content_type.match(/^(image|video)\//)
      record.image_file.purge
      record.errors[:base] << 'Wrong image format'
    end
  end
end
