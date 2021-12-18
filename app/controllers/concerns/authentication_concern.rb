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

      if auth_config.rss_token.present?
        skip_before_action :enforce_github_admin, if: :rss_token_valid?
      end
    end
  end

  def enforce_github_admin
    head :forbidden unless Authentication::Github.admin?(session)
  end

  def enforce_github_login
    head :forbidden unless Authentication::Github.login?(session)
  end

  def rss_token_valid?
    token = ::Settings.authentication.admin.rss_token
    token.present? && params[:rss_token] == token && params[:action] == 'index'
  end
end
