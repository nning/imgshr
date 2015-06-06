class GalleriesController < ApplicationController
  include ActionView::Helpers::DateHelper 
  include BossTokenAble

  http_basic_authenticate_with \
    name: Settings.authentication.username,
    password: Settings.authentication.password,
    only: [:index, :destroy]

  respond_to :html, :json

  before_filter :enforce_read_only, only: :update

  before_action :gallery, except: [:create, :index, :new]

  def create
    gallery = Gallery.create!

    boss_token_session gallery

    redirect_to gallery
  end

  def destroy
    gallery.destroy!
    redirect_to galleries_path, flash: { info: 'Gallery deleted.' }
  end

  def index
    @galleries = Gallery.includes(:pictures).order('updated_at desc').all
    session[:do_not_count] = true

    respond_to do |format|
      format.html do
      end

      format.atom do
        render layout: false
      end
    end
  end

  def show
    respond_to do |format|
      format.html do
        session["#{gallery.slug}_action"] = 'show'
        increase_visits
      end

      format.atom do
        @feed_pictures = gallery.pictures.order('created_at desc').limit(15)
        render layout: false
      end
    end
  end

  def timeline
    session["#{gallery.slug}_action"] = 'timeline'
    increase_visits

    @pictures = gallery.pictures
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
    gallery.update_attributes!(gallery_params)
    render nothing: true
  end

  private

  def gallery_params
    if boss_token
      params.require(:gallery).permit(:name, :read_only)
    elsif !gallery.read_only
      params.require(:gallery).permit(:name)
    else
      raise
    end
  end

  def increase_visits
    return if session[:do_not_count]

    unless session["counted_#{gallery.slug}"] == 1
      gallery.visits += 1
      gallery.save!
      session["counted_#{gallery.slug}"] = 1
    end
  end

  def gallery
    @gallery ||= Gallery.find_by_slug!(params[:slug])
  end
end
