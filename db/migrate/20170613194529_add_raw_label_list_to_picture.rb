class AddRawLabelListToPicture < ActiveRecord::Migration[5.1]
  def change
    add_column :pictures, :raw_label_list, :text
  end
end
