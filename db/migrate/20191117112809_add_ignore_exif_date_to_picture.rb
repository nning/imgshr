class AddIgnoreExifDateToPicture < ActiveRecord::Migration[5.2]
  def change
    add_column :pictures, :ignore_exif_date, :boolean, default: false
  end
end
