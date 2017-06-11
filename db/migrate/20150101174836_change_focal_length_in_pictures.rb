class ChangeFocalLengthInPictures < ActiveRecord::Migration[4.2]
  def change
    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      change_column :pictures, :focal_length, 'float using focal_length::double precision'
    else
      change_column :pictures, :focal_length, :float
    end
  end
end
