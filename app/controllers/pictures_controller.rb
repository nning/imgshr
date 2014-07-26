class PicturesController < ApplicationController
  respond_to :html, :json

  def create
    gallery = Gallery.find_by_id(params[:gallery_id])

    upload_params.each do |image|
      picture = gallery.pictures.build

      picture.update_attributes({image: image})
      picture.save!
    end

    redirect_to gallery_path(gallery.slug)
  end

  def update
    gallery = Gallery.find_by_id(params[:gallery_id])

    picture = gallery.pictures.find_by_id(params[:id])

    picture.update_attributes(update_params)
    picture.save!

    respond_with picture
  end

  private

  def update_params
    params.require(:picture).permit(:title)
  end

  def upload_params
    params.require(:picture).require(:image)
  end
end
