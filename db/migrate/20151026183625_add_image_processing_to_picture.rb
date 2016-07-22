class AddImageProcessingToPicture < ActiveRecord::Migration[4.2]
  def change
    add_column :pictures, :image_processing, :boolean
  end
end
