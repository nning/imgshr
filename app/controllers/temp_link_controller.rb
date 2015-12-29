class TempLinkController < ApplicationController
  def create
    gallery = Gallery.find_by_slug!(params[:slug])
    picture = gallery.pictures.find(params[:id])

    temp_link = picture.temp_links.create!

    redirect_to temp_link_path(temp_link)
  end
end
