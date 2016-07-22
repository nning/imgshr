class AddCameraToPictures < ActiveRecord::Migration[4.2]
  def up
    add_column :pictures, :camera, :string
    update!
  end

  def down
    remove_column :pictures, :camera
  end

  private

  def update!
    Picture.where.not(photographed_at: nil).find_each do |picture|
      picture.send(:set_exif_attributes)
      picture.save!
    end
  end
end
