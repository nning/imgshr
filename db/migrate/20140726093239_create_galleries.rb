class CreateGalleries < ActiveRecord::Migration
  def change
    create_table :galleries do |t|
      t.string :slug, null: false
      t.string :name
      t.timestamps
    end

    change_table :galleries do |t|
      t.index :slug, unique: true
    end
  end
end
