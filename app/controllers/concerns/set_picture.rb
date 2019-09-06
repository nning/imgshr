module SetPicture
  protected

  def picture
    @picture ||= gallery.pictures.first_by_key!(params[:id])
  end
end
