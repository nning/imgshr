module AuthenticationConcern
  def self.included(base)
    base.class_eval do
      base.extend AuthenticationConcern
    end
  end

  protected

  def authenticate!(admin_actions, login_actions)
    auth_config = ::Settings.authentication.admin

    if auth_config.github_login.nil?
      http_basic_authenticate_with \
        name: auth_config.username,
        password: auth_config.password,
        only: admin_actions + login_actions
    else
      before_action :enforce_github_admin, only: admin_actions
      before_action :enforce_github_login, only: login_actions
    end
  end

  def enforce_github_admin
    head :forbidden unless Authentication::Github.admin?(session)
  end

  def enforce_github_login
    head :forbidden unless Authentication::Github.login?(session)
  end
end
