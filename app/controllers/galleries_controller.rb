class GalleriesController < ApplicationController
  include Authentication
  include ActionView::Helpers::DateHelper
  include BossTokenAble::Controller
  include DeviceLinksOnly::Controller
  include SetGallery

  unless Rails.env.development?
    protected_actions =  [:index, :destroy]
    protected_actions << :create if Settings.disable_gallery_creation

    authenticate!(protected_actions)
  end

  respond_to :html, :json

  before_action :enforce_read_only, only: [:regenerate_slug, :create_device_link, :update]

  before_action :gallery, except: [:create, :index, :new, :device_link]

  protect_from_forgery except: :show

  def new
    if session['github_uid']
      @galleries = Gallery.joins(:boss_token)
        .where(boss_tokens: {
          github_uid: session['github_uid'].to_i
        })
        .order('updated_at desc')
    end
  end

  def create
    gallery = Gallery.create!

    boss_token_session(gallery)

    if session['github_uid']
      gallery.boss_token.update_attributes! \
        github_uid: session['github_uid'].to_i
    end

    redirect_to gallery
  end

  def destroy
    gallery.destroy!
    redirect_to galleries_path, flash: { info: 'Gallery deleted.' }
  end

  def device_link
    link = DeviceLink.where(slug: params[:slug], disabled: false).first!
    @gallery = link.gallery

    if authorized?
      message = 'Already authorized; device link still valid!'
    else
      session['device_token_' + @gallery.slug] = true
      link.disable!
      message = 'Saved device authorization. Make sure, you do not lose your session cookie!'
    end

    redirect_to gallery_path(@gallery), flash: { info: message }
  end

  def create_device_link
    @link = gallery.device_links.create!
  end

  def regenerate_slug
    gallery.regenerate_slug!

    params[:slug] = gallery.slug
    boss_token_session(gallery)

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
        render body: RQRCode::QRCode.new(gallery_url(gallery)).as_svg
      end

      format.json do
        render json: gallery, except: [:id, :slug]
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
    head :ok
  end

  private

  def gallery_params
    if boss_token
      params.require(:gallery).permit(:name, :endless_page, :ratings_enabled,
        :read_only, :device_links_only)
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
    order = :by_order_date
    order = :by_created_at if params[:sort_by] == 'created_at'

    @pictures ||= gallery.pictures
      .filtered(params)
      .send(order)
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
