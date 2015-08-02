module GalleriesHelper
  def writable?
    !(@gallery.read_only && !@boss_token)
  end
end
