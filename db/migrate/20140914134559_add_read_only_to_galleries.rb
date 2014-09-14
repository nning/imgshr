class AddReadOnlyToGalleries < ActiveRecord::Migration
  def change
    add_column :galleries, :read_only, :boolean, default: false
  end
end
