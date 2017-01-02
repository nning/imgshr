class AddDeviceLinksOnlyToGallery < ActiveRecord::Migration[5.0]
  def change
    add_column :galleries, :device_links_only, :boolean, default: false
  end
end
