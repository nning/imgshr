class GalleriesController < ApplicationController
  http_basic_authenticate_with \
    name: Settings.authentication.username,
    password: Settings.authentication.password,
    only: [:index, :destroy]

  respond_to :html, :json

  before_action :set_gallery, only: [:destroy, :show, :update]

  def create
    gallery = Gallery.create!
    redirect_to gallery
  end

  def destroy
    @gallery.destroy!
    redirect_to galleries_path, flash: { info: 'Gallery deleted.' }
  end

  def index
    @galleries = Gallery.order('updated_at desc').all
  end

  def show
    respond_to do |format|
      format.html do
        @gallery.visits += 1
        @gallery.save!
      end

      format.atom do
        @feed_pictures = @gallery.pictures.order('created_at desc').limit(15)
        render layout: false
      end
    end
  end

  def update
    @gallery.update_attributes!(gallery_params)
    respond_with @gallery
  end

  private

  def gallery_params
    params.require(:gallery).permit(:name)
  end

  def set_gallery
    @gallery = Gallery.find_by_slug(params[:slug]) || not_found
  end
end
