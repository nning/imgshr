class ChangeFlashInPictures < ActiveRecord::Migration[4.2]
  def change
    change_column :pictures, :flash, :integer
  end
end
