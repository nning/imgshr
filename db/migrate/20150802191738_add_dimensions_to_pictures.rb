class AddDimensionsToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :dimensions, :text
  end
end
