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

  def picture_grid_break(i)
    html = ''

    if i.odd?
      html << content_tag(:div, nil, class: 'row visible-xs')
    end

    if (i + 1) % 3 == 0
      html << content_tag(:div, nil, class: 'row visible-sm')
    end

    if (i + 1) % 4 == 0
      html << content_tag(:div, nil, class: 'row visible-md visible-lg')
    end

    html.html_safe
  end

  def writable?
    @gallery && !(@gallery.read_only && !@boss_token)
  end
end
