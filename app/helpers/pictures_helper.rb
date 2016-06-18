module PicturesHelper
  def exif_flash(picture)
    EXIF::FLASH_MAP[picture.flash]
  end

  def rating_for(picture)
    render 'pictures/rating', picture: picture if picture.gallery.ratings_enabled
  end

  def temp_link?
    params[:action] == 'temp_link'
  end

  def gallery_back_path(picture)
    gallery_referer?(picture) ? :back : gallery_path(picture.gallery)
  end
end
