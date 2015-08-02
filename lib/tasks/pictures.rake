namespace :pictures do
  desc 'Refresh all EXIF metadata'
  task :refresh_exif_data do
    require_relative '../../config/environment'

    ActiveRecord::Base.logger = Logger.new($stderr)

    Picture.find_each do |picture|
      picture.send(:set_exif_attributes!)
      picture.save!
    end
  end

  desc 'Refresh missing dimensions'
  task :refresh_dimensions do
    require_relative '../../config/environment'

    ActiveRecord::Base.logger = Logger.new($stderr)

    Picture.where(dimensions: nil).find_each do |picture|
      picture.send(:set_height_and_width!)
      picture.save!
    end
  end
end
