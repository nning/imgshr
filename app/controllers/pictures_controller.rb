class PicturesController < ApplicationController
  def create
    gallery = Gallery.find_by_id(params[:gallery_id])

    picture_params.each do |image|
      picture = gallery.pictures.build

      picture.update_attributes({image: image})
      picture.save!
    end

    redirect_to gallery_path(slug: gallery.slug)
  end

  private

  def picture_params
    params.require(:picture).require(:image)
  end
end
