class TempLinksController < ApplicationController
  def create
    gallery = Gallery.find_by_slug!(params[:slug])
    picture = gallery.pictures.first_by_fingerprint!(params[:id])

    temp_link = picture.temp_links.create!

    redirect_to temp_link_path(temp_link)
  end

  def show
    linkable = TempLink.find_by_slug!(params[:slug]).linkable

    case linkable
      when Gallery
        raise linkable.inspect
      when Picture
        @picture = linkable
        render 'pictures/show'
    end
  end
end
