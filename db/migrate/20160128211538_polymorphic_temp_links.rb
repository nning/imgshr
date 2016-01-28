class PolymorphicTempLinks < ActiveRecord::Migration
  def up
    rename_column :temp_links, :picture_id, :linkable_id
    add_column :temp_links, :linkable_type, :string, null: :false

    rename_index :temp_links, 'index_temp_links_on_picture_id',
      'index_temp_links_on_linkable_id'

    update_picture_links
  end

  def down
    destroy_gallery_links

    rename_index :temp_links, 'index_temp_links_on_linkable_id',
      'index_temp_links_on_picture_id'

    remove_column :temp_links, :linkable_type
    rename_column :temp_links, :linkable_id, :picture_id
  end

  private

  def destroy_gallery_links
    TempLink.where(linkable_type: 'Gallery').destroy_all
  end

  def update_picture_links
    TempLink.update_all(linkable_type: 'Picture')
  end
end
