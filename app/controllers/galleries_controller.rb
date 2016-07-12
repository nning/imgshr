class GalleriesController < ApplicationController
  include ActionView::Helpers::DateHelper 
  include BossTokenAble::Controller
  include SetGallery

  unless Rails.env.development?
    http_basic_authenticate_with \
      name: ::Settings.authentication.username,
      password: ::Settings.authentication.password,
      only: [:index, :destroy]
  end

  respond_to :html, :json

  before_action :enforce_read_only, only: [:new_slug, :update]

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

  def new_slug
    gallery.new_slug!

    params[:slug] = gallery.slug
    boss_token_session gallery

    redirect_to gallery_path(gallery),
      flash: { info: 'Regenerated gallery slug: ' + gallery.slug + '.' }
  end

  def show
    respond_to do |format|
      format.html do
        # expires_in 3.hours
        session["#{gallery.slug}_action"] = 'show'
        split_rating_param
        set_pictures
        increase_visits
      end

      format.js do
        set_pictures
      end

      format.atom do
        @feed_pictures = gallery.pictures.order('created_at desc').limit(15)
        render layout: false
      end

      format.svg do
        expires_in 7.days
        render text: RQRCode::QRCode.new(gallery_url(gallery)).as_svg
      end
    end
  end

  def index
    @galleries = Gallery.includes(:boss_token).order('updated_at desc').all
    session[:do_not_count] = true

    respond_to do |format|
      format.html

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

  def split_rating_param
    return if params[:rating].blank?

    x = params[:rating].split(',').map(&:to_i)

    if x != [1, 5]
      params[:min_rating], params[:max_rating] = x
    end
  end
end
