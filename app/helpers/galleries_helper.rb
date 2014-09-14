module GalleriesHelper
  def timeline?
    params[:action] == 'timeline'
  end

  def writable?
    !(@gallery.read_only && !@boss_token)
  end
end
