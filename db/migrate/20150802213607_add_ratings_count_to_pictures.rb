class AddRatingsCountToPictures < ActiveRecord::Migration[4.2]
  def change
    add_column :pictures, :ratings_count, :integer
  end
end
