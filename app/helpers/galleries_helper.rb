module GalleriesHelper
  def feed_item_content(picture)
    image_tag(picture.image.url(:medium), title: picture) +
      content_tag(:p, link_to("This picture is part of the #{@gallery} gallery on IMGSHR.", @gallery))
  end
end
