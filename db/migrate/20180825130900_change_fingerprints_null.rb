class ChangeFingerprintsNull < ActiveRecord::Migration[5.2]
  def change
    change_column_null :pictures, :image_fingerprint, true
    change_column_null :file_releases, :file_fingerprint, true
  end
end
