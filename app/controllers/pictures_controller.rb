class PicturesController < ApplicationController
  include BossTokenAble
  include SetGallery
  include SetPicture

  respond_to :html, :json

  before_filter :enforce_read_only, only: [:create, :update]

  skip_boss_token :show

  def create
    upload_params.each do |image|
      @picture = gallery.pictures.build

      begin
        @picture.update_attributes!({ image: image })
      rescue ActiveRecord::RecordInvalid
        redirect_to gallery, flash: {error: "Unsupported file format: #{image.content_type}!"}
        return
      end
    end
    
    if session["#{gallery.slug}_action"] == 'timeline'
      redirect_to gallery_timeline_path(gallery)
    else
      redirect_to gallery
    end
  end

  def download
    send_data \
      File.read(picture.image.path),
      filename: picture.image.original_filename,
      disposition: 'attachment',
      type: picture.image.content_type
  end

  def show
    fp = show_params[:fingerprint]

    if fp.size == 8
      @picture = Picture.where('image_fingerprint like ?', "#{fp}%").first!
    else
      @picture = Picture.find_by_image_fingerprint!(fp)
    end
  end

  def update
    picture.update_attributes!(update_params)
    respond_with picture
  end

  private
  
  def show_params
    params.permit(:fingerprint)
  end

  def update_params
    params.require(:picture).permit(:title, :tag_list)
  end

  def upload_params
    params.require(:picture).require(:image)
  end
end
