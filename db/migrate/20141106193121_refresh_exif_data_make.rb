class RefreshExifDataMake < ActiveRecord::Migration
  def up
    Rake::Task['pictures:refresh:exif_data'].invoke
  end
end
