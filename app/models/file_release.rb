class FileRelease < ApplicationRecord
  has_one_attached :download

  def to_s
    download.filename.to_s
  end
end
