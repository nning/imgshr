class RemovePaperclipFromPicturesAndFileReleases < ActiveRecord::Migration[5.2]
  def change
    remove_column :pictures, :image_updated_at, :datetime
    remove_column :pictures, :image_file_size, :bigint
    remove_column :pictures, :image_file_name, :bigint
    remove_column :pictures, :image_content_type, :string

    remove_column :file_releases, :file_file_name, :string
    remove_column :file_releases, :file_content_type, :string
    remove_column :file_releases, :file_file_size, :bigint
    remove_column :file_releases, :file_updated_at, :datetime
    remove_column :file_releases, :file_fingerprint, :string
  end
end
