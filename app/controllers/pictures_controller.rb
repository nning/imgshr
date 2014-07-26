class PicturesController < ApplicationController
  def create
    gallery = Gallery.find_by_id(params[:gallery_id])
    picture = gallery.pictures.build

    picture.update_attributes(picture_params)
    picture.save!

    redirect_to gallery_path(slug: picture.gallery.slug)
  end

  private

  def picture_params
    params.require(:picture).permit(:image)
  end
end
