class PicturesController < ApplicationController
  include BossTokenAble

  respond_to :html, :json

  before_filter :enforce_read_only, only: [:create, :update]

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

    redirect_to gallery
  end

  def download
    send_data \
      File.read(picture.image.path),
      filename: picture.image.original_filename,
      disposition: 'attachment',
      type: picture.image.content_type
  end

  def update
    picture.update_attributes!(update_params)
    respond_with picture
  end

  private

  def gallery
    @gallery ||= Gallery.find_by_slug!(params[:slug])
  end

  def picture
    @picture ||= gallery.pictures.find(params[:id])
  end
  
  def update_params
    params.require(:picture).permit(:title)
  end

  def upload_params
    params.require(:picture).require(:image)
  end
end
