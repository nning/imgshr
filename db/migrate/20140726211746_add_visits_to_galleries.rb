class AddVisitsToGalleries < ActiveRecord::Migration
  def change
    add_column :galleries, :visits, :integer, default: 0, null: false
  end
end
