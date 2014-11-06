class RefreshExifDataMake < ActiveRecord::Migration
  def up
    Picture.where.not(camera: nil).find_each do |picture|
      picture.send(:set_exif_attributes)
      picture.save!
    end
  end
end
