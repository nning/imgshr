class AddOrderDateToPictures < ActiveRecord::Migration[4.2]
  def up
    add_column :pictures, :order_date, :timestamp
    add_index :pictures, :order_date

    Rake::Task['pictures:refresh:order_date'].invoke
  end

  def down
    remove_index :pictures, :order_date
    remove_column :pictures, :order_date
  end
end
