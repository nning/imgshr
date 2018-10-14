namespace :pictures do
  desc 'Find missing attachments'
  task :find_missing_attachments do
    require_relative '../../config/environment'

    if ENV['LOG'].present?
      ActiveRecord::Base.logger = Logger.new($stderr)
    end

    Picture.find_each do |picture|
      next if picture.image_file.attachment.present?
      p picture
    end
  end

  namespace :refresh do
    desc 'Refresh all metadata'
    task :metadata do
      require_relative '../../config/environment'

      if ENV['LOG'].present?
        ActiveRecord::Base.logger = Logger.new($stderr)
      end

      Picture.find_each do |picture|
        next unless picture.image_file.attachment.present?

        begin
          picture.image_file.blob.analyze
        rescue Errno::ENOENT => err
          p err
        end
      end
    end

    desc 'Refresh order_date attributes'
    task :order_date do
      require_relative '../../config/environment'

      if ENV['LOG'].present?
        ActiveRecord::Base.logger = Logger.new($stderr)
      end

      Picture.find_each do |pic|
        if pic.photographed_at.nil?
          pic.update_column(:order_date, p.created_at)
        else
          pic.update_column(:order_date, p.photographed_at)
        end
      end
    end

    desc 'Refresh order_date attributes lazy'
    task :order_date_lazy do
      require_relative '../../config/environment'

      if ENV['LOG'].present?
        ActiveRecord::Base.logger = Logger.new($stderr)
      end

      Picture.find_each do |pic|
        if pic.photographed_at?
          pic.update_column(:order_date, pic.photographed_at)
        end
      end
    end

    [:exif_data, :dimensions].each do |name|
      desc '[OBSOLETE] Stub for old migration'
      task name do
      end
    end
  end
end
