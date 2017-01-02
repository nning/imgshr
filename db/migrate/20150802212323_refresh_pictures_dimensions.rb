class RefreshPicturesDimensions < ActiveRecord::Migration[4.2]
  def up
    Rake::Task['pictures:refresh:dimensions'].invoke
  end
end
