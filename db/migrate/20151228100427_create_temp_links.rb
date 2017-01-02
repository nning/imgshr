class CreateTempLinks < ActiveRecord::Migration[4.2]
  def change
    create_table :temp_links do |t|
      t.references :picture, index: true, foreign_key: true
      t.string :slug, null: false

      t.timestamps null: false
    end
  end
end
