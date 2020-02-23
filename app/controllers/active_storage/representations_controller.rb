# frozen_string_literal: true

if [:local, :test].include? Rails.application.config.active_storage.service
  module ActiveStorage
    class RepresentationsController < BaseController
      include ActiveStorage::SetBlob

      def show
        expires_in 1.year, public: true

        variant = @blob.representation(params[:variation_key]).processed

        send_data @blob.service.download(variant.key),
          type: @blob.content_type || DEFAULT_SEND_FILE_TYPE,
          disposition: 'inline'
      end
    end
  end
end
