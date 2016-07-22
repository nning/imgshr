class AddCameraConfigToPictures < ActiveRecord::Migration[4.2]
  def change
    change_table :pictures do |t|
      t.string  :focal_length
      t.float   :aperture
      t.string  :shutter_speed
      t.integer :iso_speed
      t.boolean :flash
    end
  end
end
