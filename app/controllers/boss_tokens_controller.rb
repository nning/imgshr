class BossTokensController < ApplicationController
  before_action :boss_token

  def destroy
    @boss_token.destroy!
    redirect_to root_path, flash: { info: 'Gallery deleted!' }
  end

  def destroy_picture
    @boss_token.gallery
      .pictures
      .first_by_fingerprint!(params[:id])
      .destroy!

    redirect_to gallery_path(@boss_token.gallery), flash: {
      info: 'Picture deleted!'
    }
  end

  def destroy_multiple_pictures
    gallery = @boss_token.gallery
    all_pictures = gallery.pictures
    pictures = all_pictures

    q = 'image_fingerprint like ?'
    flash = {}

    fingerprints = params[:pictures]

    if fingerprints && fingerprints.size > 0
      pictures = pictures.where(q, fingerprints.shift + '%')

      fingerprints.each do |fp|
        pictures = pictures.or(all_pictures.where(q, fp + '%'))
      end

      deleted_pictures = pictures.destroy_all
      flash = {
        flash: {
          notice: 'Successfully deleted %s images' % deleted_pictures.count
        }
      }
    end

    redirect_to gallery, flash
  end

  def show
    respond_to do |format|
      format.html do
        if session["boss_token_#{@boss_token.gallery.slug}"].nil?
          session["boss_token_#{@boss_token.gallery.slug}"] = @boss_token.slug
        end

        session["boss_page_visited_#{@boss_token.slug}"] = 1

        if session['github_uid'] && !@boss_token.github_uid && !admin?
          @boss_token.update_attributes!(github_uid: session['github_uid'])
        end

        if params[:redir]
          redirect_to gallery_path(boss_token.gallery)
        end
      end

      format.svg do
        expires_in 7.days
        render body: RQRCode::QRCode.new(gallery_delete_url(@boss_token)).as_svg
      end
    end
  end

  private

  def boss_token
    @boss_token ||= BossToken.find_by_slug!(params[:token])
  end
end
