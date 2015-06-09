module PicturesHelper
  def exif_flash(picture)
    EXIF::FLASH_MAP[picture.flash]
  end

  def lightbox_picture_id(picture, label: false, info: false, hash: false)
    s = "lightbox#{picture.id}"

    if label
      s = "label_#{s}"
    elsif info
      s = "info_#{s}"
    end

    s = "##{s}" if hash

    s
  end

  def picture_aria_hidden(picture)
    picture.id == params[:id].to_i ? {} : {hidden: true}
  end

  def rating_for(picture)
    render 'shared/rating', picture: picture if picture.gallery.ratings_enabled
  end
end
