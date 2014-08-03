module PicturesHelper
  def lightbox_picture_id(picture, label: false)
    s = "lightbox#{picture.id}"
    s = "label_#{s}" if label
    s
  end

  def picture_aria_hidden(picture)
    picture.id == params[:id].to_i ? {} : {hidden: true}
  end
end
