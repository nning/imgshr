class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.belongs_to :gallery, null: false
      t.attachment :image
      t.string :image_fingerprint, null: false
      t.timestamps
    end
  end
end
