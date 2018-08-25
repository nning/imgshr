class PictureImageValidator < ActiveModel::Validator
  def validate(record)
    unless record.image_file.attached?
      record.errors[:base] << 'Image missing'
      return
    end

    if record.plain?
      if !record.image_file.blob.content_type.starts_with?('image/')
        record.image_file.purge
        errors[:base] << 'Wrong image format'
      end
    else
      if record.image_file.blob.content_type != 'application/octet-stream'
        record.image_file.purge
        errors[:base] << 'Wrong image format'
      end
    end
  end
end
