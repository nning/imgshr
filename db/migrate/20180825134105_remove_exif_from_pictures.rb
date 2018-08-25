class RemoveExifFromPictures < ActiveRecord::Migration[5.2]
  def change
    remove_column :pictures, :aperture, :float
    remove_column :pictures, :camera, :string
    remove_column :pictures, :dimensions, :text
    remove_column :pictures, :flash, :integer
    remove_column :pictures, :focal_length, :float
    remove_column :pictures, :iso_speed, :integer
    remove_column :pictures, :photographed_at, :datetime
    remove_column :pictures, :shutter_speed, :string
  end
end
