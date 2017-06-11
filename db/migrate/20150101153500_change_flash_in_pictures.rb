class ChangeFlashInPictures < ActiveRecord::Migration[4.2]
  def change
    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      change_column :pictures, :flash, 'integer using flash::integer'
    else
      change_column :pictures, :flash, :integer
    end
  end
end
