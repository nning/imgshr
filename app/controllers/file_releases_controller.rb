class FileReleasesController < ApplicationController
  before_action :check_token, only: :create

  protect_from_forgery except: :create

  def index
    @file_releases = FileRelease.order('created_at desc').all
  end

  def create
    FileRelease.create!(file: params[:file], version: params[:version])
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
end
