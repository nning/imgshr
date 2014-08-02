module GalleriesHelper
  def picture_aria_hidden(picture)
    picture.id == params[:id].to_i ? {} : {hidden: true}
  end

  def feed_item_content(picture)
    image_tag(absolute_url(picture.image.url(:medium)), title: picture) +
      content_tag(:p, link_to("This picture is part of the #{@gallery} gallery on IMGSHR.", @gallery))
  end

  def lightbox_picture_id(picture, label: false)
    s = "lightbox#{picture.id}"
    s = "label_#{s}" if label
    s
  end
end
