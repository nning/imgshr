class CreatePictures < ActiveRecord::Migration[4.2]
  def change
    create_table :pictures do |t|
      t.belongs_to :gallery, null: false
      t.attachment :image
      t.string :image_fingerprint, null: false
      t.string :title
      t.datetime :photographed_at
      t.timestamps
    end
  end
end
