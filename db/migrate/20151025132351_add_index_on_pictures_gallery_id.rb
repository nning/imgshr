class AddIndexOnPicturesGalleryId < ActiveRecord::Migration
  def up
    add_index :pictures, :gallery_id
  end

  def down
    remove_index :pictures, :gallery_id
  end
end
