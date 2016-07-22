class RefreshExifDataMake < ActiveRecord::Migration[4.2]
  def up
    Rake::Task['pictures:refresh:exif_data'].invoke
  end
end
