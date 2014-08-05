class CreateDeleteToken < ActiveRecord::Migration
  def change
    create_table :delete_tokens do |t|
      t.string :slug, null: false
      t.belongs_to :gallery
    end

    change_table :delete_tokens do |t|
      t.index :slug, unique: true
      t.index :gallery_id, unique: true
    end
  end
end
