class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :picture, index: true, foreign_key: true
      t.integer :value, null: false

      t.timestamps null: false
    end
  end
end
