class GalleriesController < ApplicationController
  include ActionView::Helpers::DateHelper 

  http_basic_authenticate_with \
    name: Settings.authentication.username,
    password: Settings.authentication.password,
    only: [:index, :destroy]

  respond_to :html, :json

  before_action :set_gallery, only: [:destroy, :show, :timeline, :update]
  before_action :set_delete_token, only: [:show, :timeline]

  def create
    gallery = Gallery.create!

    session["delete_token_#{gallery.slug}"] = gallery.delete_token.slug

    redirect_to gallery
  end

  def destroy
    @gallery.destroy!
    redirect_to galleries_path, flash: { info: 'Gallery deleted.' }
  end

  def index
    @galleries = Gallery.includes(:pictures).order('updated_at desc').all
    session[:do_not_count] = true
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

    return if session[:do_not_count]

    unless session["counted_#{@gallery.slug}"] == 1
      @gallery.visits += 1
      @gallery.save!
      session["counted_#{@gallery.slug}"] = 1
    end
  end

  def set_delete_token
    if session["delete_token_#{@gallery.slug}"]
      @delete_token ||= DeleteToken.find_by_slug(session["delete_token_#{@gallery.slug}"])
    end
  end

  def set_gallery
    @gallery ||= Gallery.find_by_slug!(params[:slug])
  end
end
