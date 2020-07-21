class PictureImageValidator < ActiveModel::Validator
  def validate(record)
    unless record.image_file.attached?
      record.errors[:base] << 'Image missing'
      return
    end

    return unless record.plain?

    if !record.image_file.blob.content_type.starts_with?('image/')
      # TODO Purge uploaded file
      record.errors[:base] << 'Wrong file format'
      return
    end

    new_checksum = record.image_file.blob.checksum
    existing_pictures = record.gallery.pictures
      .includes(:image_file_blob)
      .where(active_storage_blobs: {checksum: new_checksum})

    if existing_pictures.any?
      # TODO Purge uploaded file
      record.errors[:base] << "Image already exists in gallery"
      return
    end
  end
end
