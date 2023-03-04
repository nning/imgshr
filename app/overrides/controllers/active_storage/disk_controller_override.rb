# frozen_string_literal: true
# See https://github.com/rails/rails/blob/v7.0.4.2/activestorage/app/controllers/active_storage/disk_controller.rb#L12

if [:local, :test].include?(Rails.application.config.active_storage.service) && !ActiveStorage::DiskController.instance_methods.include?(:_show)
  ActiveStorage::DiskController.class_eval do
    alias_method :_show, :show

    def show
      content_type = ContentType.convert_format(request)
      return _show if !content_type

      if key = decode_verified_key
        serve_file named_disk_service(key[:service_name]).path_for(key[:key]), content_type: content_type, disposition: key[:disposition]
      else
        head :not_found
      end
    rescue Errno::ENOENT
      head :not_found
    end
  end
end
