class GalleriesController < ApplicationController
  include ActionView::Helpers::DateHelper 
  include BossTokenAble
  include SetGallery

  unless Rails.env.development?
    http_basic_authenticate_with \
      name: Settings.authentication.username,
      password: Settings.authentication.password,
      only: [:index, :destroy]
  end

  respond_to :html, :json

  before_filter :enforce_read_only, only: :update

  before_action :gallery, except: [:create, :index, :new]

  protect_from_forgery except: :show

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
    @galleries = Gallery.includes(:boss_token).order('updated_at desc').all
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
        set_picture_groups
        increase_visits
      end

      format.js do
        set_picture_groups
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

    @picture_groups ||= {}
    @picture_times  ||= {}

    @time = Time.now

    @pictures.each do |picture|
      group = time_ago_in_words(picture.photographed_or_created_at)

      @picture_groups[group] ||= picture.photographed_or_created_at

      time = @picture_groups[group]

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
      params.require(:gallery).permit(:name, :ratings_enabled, :read_only)
    elsif !gallery.read_only
      params.require(:gallery).permit(:name)
    else
      raise
    end
  end

  def increase_visits
    return if session[:do_not_count]

    unless session["counted_#{gallery.slug}"]
      gallery.increase_visits!
      session["counted_#{gallery.slug}"] = true
    end
  end

  def set_picture_groups
    @pictures = gallery.pictures.grid

    if params[:id] && !params[:page]
      @picture = @pictures.find(params[:id])
      offset = Picture.grid.where('created_at > ?', @picture.created_at).count
      page = offset / Picture.default_per_page + 1
      redirect_to gallery_path(gallery, id: params[:id], page: page)
    end

    @pictures = @pictures.page(params[:page])
    @picture_groups = @pictures.in_groups_of(4, false)
  end
end
