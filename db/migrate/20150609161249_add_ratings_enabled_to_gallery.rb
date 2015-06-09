class AddRatingsEnabledToGallery < ActiveRecord::Migration
  def change
    add_column :galleries, :ratings_enabled, :boolean, default: true, null: false
  end
end
