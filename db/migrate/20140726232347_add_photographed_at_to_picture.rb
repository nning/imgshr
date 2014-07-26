class AddPhotographedAtToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :photographed_at, :datetime
  end
end
