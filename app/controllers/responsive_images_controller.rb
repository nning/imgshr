# frozen_string_literal: true

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

    type = image.blob.content_type || DEFAULT_SEND_FILE_TYPE

    if convert_type = ContentType.convert_format(request)
      options[:convert] = type.split('/').last
      type = convert_type
    end

    # Generate variant file
    variant = image.variant(options).processed

    send_data image.service.download(variant.key),
      type: type,
      disposition: 'inline'
  end

  private

  def show_params
    params.permit(:key, *OPTIONS)
  end
end
