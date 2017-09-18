module Authentication
  def self.included(base)
    base.class_eval do
      base.extend Authentication
    end
  end

  protected

  def authenticate!(protected_actions)
    auth_config = ::Settings.authentication.admin

    if auth_config.github_login.nil?
      http_basic_authenticate_with \
        name: auth_config.username,
        password: auth_config.password,
        only: protected_actions
    else
      before_action :enforce_github_login, only: protected_actions
    end
  end

  def enforce_github_login
    if session['github_login'] != Settings.authentication.admin.github_login
      head :forbidden
    end
  end
end
