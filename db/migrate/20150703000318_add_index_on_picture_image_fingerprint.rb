class AddIndexOnPictureImageFingerprint < ActiveRecord::Migration[4.2]
  def change
    change_table :pictures do |t|
      t.index :image_fingerprint
    end
  end
end
