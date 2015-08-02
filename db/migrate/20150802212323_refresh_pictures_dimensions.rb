class RefreshPicturesDimensions < ActiveRecord::Migration
  def up
    Rake::Task['pictures:refresh_dimensions'].invoke
  end
end
