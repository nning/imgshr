class GalleriesController < ApplicationController
  http_basic_authenticate_with \
    name: Settings.authentication.username,
    password: Settings.authentication.password,
    only: :index

  respond_to :html, :json

  def create
    gallery = Gallery.create
    redirect_to gallery_path(slug: gallery.slug)
  end

  def index
    @galleries = Gallery.order('updated_at desc').all
  end

  def show
    @gallery = Gallery.find_by_slug(params[:slug]) || not_found
  end

  def update
    @gallery = Gallery.find_by_id(params[:id])
    @gallery.update_attributes(gallery_params)
    respond_with @gallery
  end

  private

  def gallery_params
    params.require(:gallery).permit(:name)
  end
end
