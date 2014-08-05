module GalleriesHelper
  def feed_item_content(picture)
    image_tag(absolute_url(picture.image.url(:medium)), title: picture) +
      content_tag(:p, link_to("This picture is part of the #{@gallery} gallery on IMGSHR.", @gallery))
  end

  def timeline?
    params[:action] == 'timeline'
  end
end
