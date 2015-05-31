class RatingsController < ApplicationController
  include SetGallery
  include SetPicture

  def show
    render json: picture.average_rating
  end
end
