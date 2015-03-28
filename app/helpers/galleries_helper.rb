module GalleriesHelper
  def time_id(time, hash = true)
    s  = ''
    s << '#' if hash
    s << 'time-'
    s << time.parameterize
  end

  def timeline?
    params[:action] == 'timeline'
  end

  def writable?
    !(@gallery.read_only && !@boss_token)
  end
end
