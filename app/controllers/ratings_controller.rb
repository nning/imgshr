class RatingsController < ApplicationController
  include SetGallery
  include SetPicture

  def create
    if session[rated_cookie] || !gallery.ratings_enabled
      head :forbidden
    else
      picture.ratings.create!(create_params)
      session[rated_cookie] = true
      head :no_content
    end
  end

  def show
    render json: picture.average_rating
  end

  private

  def create_params
    params.require(:picture).permit(:score)
  end

  def rated_cookie
    ['rated', gallery.slug, picture.id].join('_')
  end
end
