class RefreshPicturesDimensions < ActiveRecord::Migration
  def up
    Rake::Task['pictures:refresh:dimensions'].invoke
  end
end
