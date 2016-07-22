class CreateGalleries < ActiveRecord::Migration[4.2]
  def change
    create_table :galleries do |t|
      t.string :slug, null: false
      t.string :name
      t.integer :visits, default: 0, null: false
      t.timestamps
    end

    change_table :galleries do |t|
      t.index :slug, unique: true
    end
  end
end
