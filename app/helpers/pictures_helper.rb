module PicturesHelper
  GRID_TILE_HEIGHT = 325

  def exif_flash(picture)
    Exif::FLASH_MAP[picture.flash]
  end

  # Returns the CSS aspect-ratio value ("w / h") for the picture's original
  # dimensions, or nil when analysis has not run yet (e.g. attachment still
  # being processed). Used to reserve layout space before the image bytes
  # arrive, avoiding cumulative layout shift.
  def picture_aspect_ratio(picture)
    return nil unless picture.width? && picture.height?
    return nil if picture.width.to_f.zero? || picture.height.to_f.zero?
    "#{picture.width} / #{picture.height}"
  end

  # Intrinsic width/height attributes for an <img>, scaled to the grid tile
  # height so the browser can size the box before load. Returns {} when
  # dimensions are unknown.
  def picture_intrinsic_attrs(picture, height: GRID_TILE_HEIGHT)
    return {} unless picture.width? && picture.height?
    return {} if picture.height.to_f.zero?
    { width: (height * picture.width.to_f / picture.height).round, height: height }
  end

  def hide_gallery?
    temp_link? || params[:action] == 'show'
  end

  def rating_for(picture)
    render 'pictures/rating', picture: picture if picture.gallery.ratings_enabled
  end

  def temp_link?
    params[:controller] == 'temp_links' && params[:action] == 'show'
  end
end
