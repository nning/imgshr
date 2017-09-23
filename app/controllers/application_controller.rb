class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected

  def admin?
    Authentication.admin?(request, session)
  end
end
