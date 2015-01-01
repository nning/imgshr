class ChangeFocalLengthInPictures < ActiveRecord::Migration
  def change
    change_column :pictures, :focal_length, :float
  end
end
