# frozen_string_literal: true

if [:local, :test].include? Rails.application.config.active_storage.service
  module ActiveStorage
    class RepresentationsController < BaseController
      include ActiveStorage::SetBlob

      def show
        expires_in 1.year, public: true

        type = @blob.content_type || DEFAULT_SEND_FILE_TYPE

        original_variant = @blob.representation(params[:variation_key])

        if convert_to_webp?
          options = original_variant.variation.transformations.merge({convert: 'webp'})
          variant = @blob.variant(options).processed
          type = 'image/webp'
        else
          variant = original_variant.processed
        end

        send_data @blob.service.download(variant.key),
          type: type, disposition: 'inline'
      end

      private

      def convert_to_webp?
        request.headers['Accept'] =~ /image\/webp/ && Settings.convert_to_webp
      end
    end
  end
end
