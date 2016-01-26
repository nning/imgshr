class FileReleasesController < ApplicationController
  before_action :check_token, only: :create

  protect_from_forgery except: :create

  def index
    @file_releases = FileRelease.order('created_at desc').first(15)
  end

  def create
    FileRelease.create!(create_params)
    head :ok
  end

  private

  def authorized?
    token = params[:token]
    !token.nil? && token == Settings.file_release_token
  end

  def check_token
    head :forbidden unless authorized?
  end

  def create_params
    params.permit(:branch, :file, :version)
  end
end
