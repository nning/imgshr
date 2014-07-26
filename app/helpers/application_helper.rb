module ApplicationHelper
  # Helper for glyphicon span tags.
  def icon(name, options = {})
    name = name.to_s.gsub(/_/, '-')
    content_tag :span, nil, class: "glyphicon glyphicon-#{name} #{options[:class]}"
  end
end
