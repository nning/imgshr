class RefreshExifDataMake < ActiveRecord::Migration
  def up
    Rake::Task['pictures:refresh_exif_data'].invoke
  end
end
