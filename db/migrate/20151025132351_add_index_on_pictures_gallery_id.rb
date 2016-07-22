class AddIndexOnPicturesGalleryId < ActiveRecord::Migration[4.2]
  def up
    add_index :pictures, :gallery_id
  end

  def down
    remove_index :pictures, :gallery_id
  end
end
