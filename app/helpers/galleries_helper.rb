module GalleriesHelper
  def any_filters?
    params[:tags] || params[:since] || params[:until]
  end

  def filter_params
    {
      tags: params[:tags],
      since: params[:since],
      until: params[:until]
    }
  end

  def no_filters?
    !any_filters?
  end

  def writable?
    @gallery && !(@gallery.read_only && !@boss_token)
  end
end
