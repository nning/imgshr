class AddClientEncryptedToGallery < ActiveRecord::Migration[5.2]
  def change
    add_column :galleries, :client_encrypted, :boolean, default: false
  end
end
