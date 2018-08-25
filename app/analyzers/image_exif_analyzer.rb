require 'exifr/jpeg'

class ImageExifAnalyzer < ActiveStorage::Analyzer::ImageAnalyzer
  alias_method :dimensions_metadata, :metadata

  def metadata
    read_image do |image|
      return {} unless image.type == 'JPEG'

      exif = EXIFR::JPEG.new(image.path)
      h = dimensions_metadata.merge({
        camera: exif_camera_string(exif),
        photographed_at: exif.date_time_digitized,
        aperture: exif.aperture_value || exif.f_number,
        shutter_speed: exif.shutter_speed_value || exif.exposure_time,
        iso_speed: exif.iso_speed_ratings,
        flash: exif.flash
      })

      unless exif.focal_length.nil?
        h[:focal_length] = exif.focal_length.to_f.round(3)
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
end
