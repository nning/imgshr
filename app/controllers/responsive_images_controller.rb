class ResponsiveImagesController < ApplicationController
  OPTIONS = [:resize, :quality, :rotate]

  def show
    expires_in 1.year, public: true

    picture = Picture.first_by_key!(show_params[:key])
    image = picture.image_file

    if !picture.gallery.responsive_image_service
      head :forbidden and return
    end

    options = show_params.to_hash.select { |k, v| OPTIONS.include?(k.to_sym) }
    options[:convert] = 'web' if webp?

    type = image.blob.content_type || DEFAULT_SEND_FILE_TYPE
    type = 'image/webp' if webp?

    variant = image.variant(options)

    # Generate variant file
    image.blob.representation(variant.variation.key).processed

    send_data image.service.download(variant.key),
      type: type,
      disposition: 'inline'
  end

  private

  def show_params
    params.permit(:key, *OPTIONS)
  end

  def webp?
    request.headers['Accept'] =~ /image\/webp/
  end
end
