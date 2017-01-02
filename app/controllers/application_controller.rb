class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected

  def admin?
    BasicAuth.logged_in?(request)
  end
end
