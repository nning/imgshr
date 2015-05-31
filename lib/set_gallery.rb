module SetGallery
  protected

  def gallery
    @gallery ||= Gallery.find_by_slug!(params[:slug])
  end
end
