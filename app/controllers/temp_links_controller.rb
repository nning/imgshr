class TempLinksController < ApplicationController
  def create
    gallery = Gallery.find_by_slug!(params[:slug])
    picture = gallery.pictures.first_by_fingerprint!(params[:id])

    temp_link = picture.temp_links.create!

    redirect_to temp_link_path(temp_link)
  end

  def show
    @picture = TempLink.find_by_slug!(params[:slug]).picture
    render 'pictures/show'
  end
end
