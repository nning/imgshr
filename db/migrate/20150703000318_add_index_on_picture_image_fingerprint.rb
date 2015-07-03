class AddIndexOnPictureImageFingerprint < ActiveRecord::Migration
  def change
    change_table :pictures do |t|
      t.index :image_fingerprint
    end
  end
end
