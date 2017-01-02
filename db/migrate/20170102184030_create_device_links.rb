class CreateDeviceLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :device_links do |t|
      t.references :gallery, foreign_key: true, index: true
      t.string :slug, null: false
      t.boolean :disabled, null: false, default: false

      t.timestamps null: false
    end

    change_table :device_links do |t|
      t.index :slug, unique: true
    end
  end
end
