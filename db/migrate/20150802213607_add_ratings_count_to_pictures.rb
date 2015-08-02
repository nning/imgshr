class AddRatingsCountToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :ratings_count, :integer
  end
end
