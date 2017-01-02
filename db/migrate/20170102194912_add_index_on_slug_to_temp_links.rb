class AddIndexOnSlugToTempLinks < ActiveRecord::Migration[5.0]
  def change
    change_table :temp_links do |t|
      t.index :slug, unique: true
    end
  end
end
