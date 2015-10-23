module GalleriesHelper
  def writable?
    @gallery && !(@gallery.read_only && !@boss_token)
  end
end
