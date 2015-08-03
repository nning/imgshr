class AddEndlessPageToGalleries < ActiveRecord::Migration
  def change
    add_column :galleries, :endless_page, :boolean, default: true, null: false
  end
end
