class AddRatingsEnabledToGallery < ActiveRecord::Migration[4.2]
  def change
    add_column :galleries, :ratings_enabled, :boolean, default: true, null: false
  end
end
