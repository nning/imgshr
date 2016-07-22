class AddEndlessPageToGalleries < ActiveRecord::Migration[4.2]
  def change
    add_column :galleries, :endless_page, :boolean, default: true, null: false
  end
end
