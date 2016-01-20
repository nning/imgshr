class FileReleasesController < ApplicationController
  def index
    @file_releases = FileRelease.order('created_at desc').all
  end
end
