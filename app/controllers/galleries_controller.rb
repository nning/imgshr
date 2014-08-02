class GalleriesController < ApplicationController
  include ActionView::Helpers::DateHelper 

  http_basic_authenticate_with \
    name: Settings.authentication.username,
    password: Settings.authentication.password,
    only: [:index, :destroy]

  respond_to :html, :json

  before_action :set_gallery, only: [:destroy, :show, :timeline, :update]

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
        increase_visits
      end

      format.atom do
        @feed_pictures = @gallery.pictures.order('created_at desc').limit(15)
        render layout: false
      end
    end
  end

  def timeline
    increase_visits

    @pictures = @gallery.pictures
      .sort_by { |p| p.photographed_at ? p.photographed_at : p.created_at }
      .reverse

    @picture_times ||= {}

    @time = Time.now

    @pictures.each do |picture|
      time = time_ago_in_words(picture.photographed_or_created_at) + ' ago'
      @picture_times[time] ||= []
      @picture_times[time] << picture
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

  def increase_visits
    set_gallery
    @gallery.visits += 1
    @gallery.save!
  end

  def set_gallery
    @gallery ||= Gallery.find_by_slug(params[:slug]) || not_found
  end
end
