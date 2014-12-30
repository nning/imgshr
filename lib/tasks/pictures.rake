namespace :pictures do
  desc 'Refresh all EXIF metadata'
  task :refresh_exif_data do
    require_relative '../../config/environment'

    ActiveRecord::Base.logger = Logger.new($stderr)

    Picture.where.not(camera: nil).find_each do |picture|
      picture.send(:set_exif_attributes)
      picture.save!
    end
  end
end
