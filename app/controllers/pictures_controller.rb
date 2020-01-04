class PicturesController < ApplicationController
  include BossTokenAble::Controller
  include SetGallery
  include SetPicture

  include ApplicationHelper

  unless Rails.env.development?
    http_basic_authenticate_with \
      name: ::Settings.authentication.username,
      password: ::Settings.authentication.password,
      only: [:index]
  end

  respond_to :html, :json

  before_action :enforce_read_only, only: [:api_create, :create, :update]

  skip_boss_token :show

  protect_from_forgery except: :api_create

  def api_create
    create
  end

  def create
    # p upload_params

    upload_params.each do |image|
      @picture = gallery.pictures.build

      begin
        @picture.image_file.attach(image)
        @picture.save!
      rescue ActiveRecord::RecordInvalid
        redirect_to gallery, flash: { error: @picture.errors.full_messages.join(', ') }
        return
      end
    end

    redirect_to gallery unless request.xhr?
  end

  def gallery_show
    @gallery = Gallery.find_by_slug!(gallery_show_params[:slug])
    @picture = @gallery.pictures.first_by_key!(gallery_show_params[:key])

    @milestones = @gallery.milestones.show_on_pictures

    render :show
  end

  def show
    @picture = Picture.first_by_key!(show_params[:key])
    @milestones = picture.gallery.milestones.show_on_pictures
  end

  def update
    picture.update!(update_params)
    head :ok
  end

  def index
    @pictures = Picture.order('created_at desc').limit(50)
  end

  private

  def gallery_show_params
    params.permit(:slug, :key)
  end

  def show_params
    params.permit(:key)
  end

  def update_params
    params.require(:picture).permit(:title, :tag_list, :ignore_exif_date)
  end

  def upload_params
    params.require(:picture).require(:image)
  end
end
