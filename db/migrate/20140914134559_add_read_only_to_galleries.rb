class AddReadOnlyToGalleries < ActiveRecord::Migration[4.2]
  def change
    add_column :galleries, :read_only, :boolean, default: false
  end
end
