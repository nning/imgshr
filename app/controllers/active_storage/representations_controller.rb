# frozen_string_literal: true

if Rails.application.config.active_storage.service == :local
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
else
  prefix = $LOAD_PATH.grep(/activestorage.*controllers/).first
  load prefix + '/active_storage/representations_controller.rb'
end
