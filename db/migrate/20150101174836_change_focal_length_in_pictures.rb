class ChangeFocalLengthInPictures < ActiveRecord::Migration[4.2]
  def change
    change_column :pictures, :focal_length, :float
  end
end
