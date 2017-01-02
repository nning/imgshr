class CreateFileRelease < ActiveRecord::Migration[4.2]
  def change
    create_table :file_releases do |t|
      t.attachment :file
      t.string :file_fingerprint, null: false
      t.string :version
      t.timestamps
    end
  end
end
