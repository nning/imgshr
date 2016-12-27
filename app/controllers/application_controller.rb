class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected

  def admin?
    BasicAuth.admin?(request)
  end
end
