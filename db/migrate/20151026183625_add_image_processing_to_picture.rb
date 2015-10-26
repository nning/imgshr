class AddImageProcessingToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :image_processing, :boolean
  end
end
