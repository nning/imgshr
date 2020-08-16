module SetPicture
  protected

  def picture
    @picture ||= gallery.pictures.with_attached_image_file.first_by_key!(params[:id])
  end
end
