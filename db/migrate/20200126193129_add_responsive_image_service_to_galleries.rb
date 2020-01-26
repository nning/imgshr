class AddResponsiveImageServiceToGalleries < ActiveRecord::Migration[6.0]
  def change
    add_column :galleries, :responsive_image_service, :boolean, default: false
  end
end
