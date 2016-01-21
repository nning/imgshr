class FileRelease < ActiveRecord::Base
  has_attached_file :file,
    url: '/system/:class/:id/:filename'

  # validates_attachment_content_type :file, content_type: /\Aapplication\/java-archive/
  do_not_validate_attachment_file_type :file

  def to_s
    file.original_filename
  end
end
