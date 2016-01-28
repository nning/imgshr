class BossTokensController < ApplicationController
  before_action :boss_token

  def destroy
    @boss_token.destroy!
    redirect_to root_path, flash: {info: 'Gallery deleted!'}
  end

  def destroy_picture
    @boss_token.gallery.pictures.find(params[:id]).destroy!
    redirect_to gallery_path(@boss_token.gallery), flash: {info: 'Picture deleted!'}
  end

  def show
    respond_to do |format|
      format.html do
        if session["boss_token_#{@boss_token.gallery.slug}"].nil?
          session["boss_token_#{@boss_token.gallery.slug}"] = @boss_token.slug
        end

        session["boss_page_visited_#{@boss_token.slug}"] = 1

        redirect_to gallery_path(boss_token.gallery) if params[:redir]
      end

      format.svg do
        expires_in 7.days
        render text: RQRCode::QRCode.new(gallery_delete_url(@boss_token)).as_svg
      end
    end
  end

  private

  def boss_token
    @boss_token ||= BossToken.find_by_slug!(params[:token])
  end
end
