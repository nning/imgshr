module GalleriesHelper
  def feed_item_content(picture)
    image_tag(picture.image.url(:medium), title: picture) +
      content_tag(:p, link_to("Visit #{@gallery} on IMGSHR!", @gallery))
  end
end
