class PicturesController < ApplicationController
  respond_to :html, :json

  before_action :set_gallery

  def create
    upload_params.each do |image|
      picture = @gallery.pictures.build

      picture.update_attributes!({ image: image })
    end

    redirect_to @gallery
  end

  def update
    picture = @gallery.pictures.find_by_id(params[:id]) || not_found

    picture.update_attributes!(update_params)

    respond_with picture
  end

  private

  def set_gallery
    @gallery = Gallery.find_by_slug(params[:slug]) || not_found
  end

  def update_params
    params.require(:picture).permit(:title)
  end

  def upload_params
    params.require(:picture).require(:image)
  end
end
