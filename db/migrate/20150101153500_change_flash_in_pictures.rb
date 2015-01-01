class ChangeFlashInPictures < ActiveRecord::Migration
  def change
    change_column :pictures, :flash, :integer
  end
end
