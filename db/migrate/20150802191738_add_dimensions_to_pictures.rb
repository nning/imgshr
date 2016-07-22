class AddDimensionsToPictures < ActiveRecord::Migration[4.2]
  def change
    add_column :pictures, :dimensions, :text
  end
end
