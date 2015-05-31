module SetPicture
  protected

  def picture
    @picture ||= gallery.pictures.find(params[:id])
  end
end
