module SetPicture
  protected

  def picture
    @picture ||= gallery.pictures.first_by_fingerprint!(params[:id])
  end
end
