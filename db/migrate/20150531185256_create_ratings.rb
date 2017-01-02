class CreateRatings < ActiveRecord::Migration[4.2]
  def change
    create_table :ratings do |t|
      t.references :picture, index: true, foreign_key: true
      t.integer :score, null: false

      t.timestamps null: false
    end
  end
end
