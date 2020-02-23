module GalleriesHelper
  def any_filters?
    params[:tags] || params[:since] || params[:until] || params[:min_rating] ||
      params[:max_rating]
  end

  def filter_params
    {
      tags: params[:tags],
      since: params[:since],
      until: params[:until],
      sort_by: params[:sort_by],
      min_rating: params[:min_rating],
      max_rating: params[:max_rating],
      reverse: params[:reverse]
    }
  end

  def gallery_back_path(gallery, params = {})
    referer = request.referer
    referer = gallery_path(gallery) unless gallery_referer?(gallery)
    merge_query(URI(referer), params).to_s
  end

  def no_filters?
    !any_filters?
  end

  def rating_slider_attributes
    h = { slider_min: 1, slider_max: 5, slider_value: [1, 5] }

    unless params[:rating].blank?
      h.merge!(slider_value: '[%s]' % params[:rating])
    end

    h
  end

  def writable?
    @gallery && !(@gallery.read_only && !@boss_token)
  end
end
