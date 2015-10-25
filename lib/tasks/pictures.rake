namespace :pictures do
  desc 'Refresh missing dimensions'
  task :refresh_dimensions do
    require_relative '../../config/environment'

    ActiveRecord::Base.logger = Logger.new($stderr)

    Picture.where(dimensions: nil).find_each do |picture|
      picture.send(:set_height_and_width!)
      picture.save!
    end
  end

  desc 'Refresh all EXIF metadata'
  task :refresh_exif_data do
    require_relative '../../config/environment'

    ActiveRecord::Base.logger = Logger.new($stderr)

    Picture.find_each do |picture|
      picture.send(:set_exif_attributes)
      picture.save!
    end
  end

  desc 'Refresh order_date attributes'
  task :refresh_order_date do
    require_relative '../../config/environment'

    ActiveRecord::Base.logger = Logger.new($stderr)

    Picture.find_each do |p|
      if p.photographed_at.nil?
        p.update_column(:order_date, p.created_at)
      else
        p.update_column(:order_date, p.photographed_at)
      end
    end
  end
end
