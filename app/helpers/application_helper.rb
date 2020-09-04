module ApplicationHelper
  def absolute_url_for(relative_url)
    relative_url = url_for(relative_url) unless relative_url.is_a? String
    (URI(request.url) + relative_url).to_s
  end

  def admin?
    Authentication.admin?(request, session)
  end

  def brand
    content_tag :div, class: 'imgshr-brand' do
      icon(:picture, class: 'imgshr-icon') + 'IMGSHR'
    end
  end

  def controller_class
    params[:controller] + '-' + params[:action]
  end

  # Convert flash message type to bootstrap class.
  def flash_class(type)
    ({notice: :info, alert: :warning, error: :danger}[type.to_sym] || type).to_s
  end

  def gallery_referer?(gallery)
    return false unless request.referer
    URI(request.referer).path == url_for(gallery)
  end

  # Helper for glyphicon span tags.
  def icon(name, options = {})
    name = name.to_s.gsub(/_/, '-')
    content_tag :span, nil, {
      class: "glyphicon glyphicon-#{name} #{options[:class]}",
      id: options[:id]
    }
  end

  def merge_query(uri, query)
    q = Rack::Utils.parse_nested_query(uri.query)
    q = HashWithIndifferentAccess.new(q)
    q.merge!(query)

    uri.query = Rack::Utils.build_nested_query(q)
    uri
  end

  def logged_in?
    login_name.present? && session['github_uid'].present?
  end

  def login_name
    session['github_login']
  end

  def show_list_button?
    return true if Authentication.basic? || Rails.env.development?
    Authentication::Github.admin?(session)
  end

  def show_create_button?
    creation_enabled = Settings.gallery_creation &&
      !Settings.gallery_creation.disable

    github_login = Settings.gallery_creation &&
      Settings.gallery_creation.github

    if github_login
      return creation_enabled && logged_in?
    end

    creation_enabled
  end

  def show_login_invitation?
    c = Settings.gallery_creation
    return c && !c.disable && c.github
  end
end
