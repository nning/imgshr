class DeleteTokensController < ApplicationController
  before_action :set_delete_token

  def destroy
    @delete_token.destroy!
    redirect_to root_path, flash: {info: 'Gallery deleted!'}
  end

  def destroy_picture
    @delete_token.gallery.pictures.find(params[:id]).destroy!
    redirect_to gallery_path(@delete_token.gallery), flash: {info: 'Picture deleted!'}
  end

  def show
    if session["delete_token_#{@delete_token.gallery.slug}"].nil?
      session["delete_token_#{@delete_token.gallery.slug}"] = @delete_token.slug
    end

    session["delete_page_visited_#{@delete_token.slug}"] = 1
  end

  private

  def set_delete_token
    @delete_token ||= DeleteToken.find_by_slug!(params[:token])
  end
end
