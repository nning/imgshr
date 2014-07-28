module ApplicationHelper
  def absolute_url(relative_url)
    URI(request.url) + relative_url
  end

  def brand
    content_tag :div, class: 'imgshr-brand' do
      icon(:picture, class: 'imgshr-icon') + 'IMGSHR'
    end
  end

  # Convert flash message type to bootstrap class.
  def flash_class(type)
    ({notice: :info, alert: :warning, error: :danger}[type.to_sym] || type).to_s
  end

  # Helper for glyphicon span tags.
  def icon(name, options = {})
    name = name.to_s.gsub(/_/, '-')
    content_tag :span, nil, class: "glyphicon glyphicon-#{name} #{options[:class]}", id: options[:id]
  end
end
