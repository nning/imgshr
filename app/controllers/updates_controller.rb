class UpdatesController < ApplicationController
  before_action :check_token, only: :create

  protect_from_forgery except: :create

  def create
    if File.exists?(Rails.root.join('update.sh'))
      UpdateJob.perform_later
      head :ok and return
    end

    head :not_found
  end

  private

  def authorized?
    token = params[:token]
    !token.nil? && token == Settings.updates_token
  end

  def check_token
    head :forbidden unless authorized?
  end
end
