class GalleriesController < ApplicationController
  include ActionView::Helpers::DateHelper 
  include BossTokenAble
  include SetGallery

  unless Rails.env.development?
    http_basic_authenticate_with \
      name: ::Settings.authentication.username,
      password: ::Settings.authentication.password,
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

      format.svg do
        render text: RQRCode::QRCode.new(gallery_url(gallery)).as_svg
      end
    end
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

  def timeline
    redirect_to action: :show, status: :moved_permanently
  end

  def update
    gallery.update_attributes!(gallery_params)
    render nothing: true
  end

  private

  def gallery_params
    if boss_token
      params.require(:gallery).permit(:name, :endless_page, :ratings_enabled, :read_only)
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

  def set_pictures
    @pictures ||= gallery.pictures
      .filtered(params)
      .by_order_date
      .page(params[:page])
  rescue ArgumentError
    raise ActiveRecord::RecordNotFound
  end

  def set_picture_groups
    @pictures       ||= set_pictures
    @picture_groups ||= @pictures.in_groups_of(4, false)
  end
end
