require 'exifr/jpeg'

# TODO ImageAnalyzer.read_image is not found after upgrade to Rails 7
class ImageExifAnalyzer < ActiveStorage::Analyzer::ImageAnalyzer::ImageMagick
  alias_method :dimensions_metadata, :metadata

  def metadata
    read_image do |image|
      h = dimensions_metadata

      if image.type == 'JPEG'
        exif = EXIFR::JPEG.new(image.path)
        h.merge!({
          camera: exif_camera_string(exif),
          photographed_at: exif.date_time_digitized || exif.date_time,
          aperture: exif.aperture_value || exif.f_number,
          shutter_speed: exif.shutter_speed_value || exif.exposure_time,
          iso_speed: exif.iso_speed_ratings,
          flash: exif.flash,
          software: exif.software,
          hdr: exif_hdr(exif.software)
        })

        unless exif.focal_length.nil?
          h[:focal_length] = exif.focal_length.to_f.round(3)
        end
      end

      # TODO ActiveStorage misses an after_analyze callback, so this is a
      # work-around to set order_date on Picture after EXIF data has been
      # extracted
      blob.attachments.each do |attachment|
        pic = attachment.record

        pic.order_date = h[:photographed_at] || pic&.created_at || Time.now
        pic.save!
      end

      h
    end
  rescue LoadError
    logger.info 'Skipping image analysis because the mini_magick gem is not installed'
    {}
  rescue EXIFR::MalformedImage, EXIFR::MalformedJPEG
    logger.warning 'Skipping image analysis because of malformed image'
    {}
  end

  private

  def exif_camera_string(exif)
    camera = exif.model

    if !(exif.make.blank? || camera.starts_with?(exif.make))
      camera = [exif.make, camera].join(' ')
    end

    camera
  end

  def exif_hdr(software)
    software.present? && software.starts_with?(/hdr/i)
  end
end
