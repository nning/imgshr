class RatingsController < ApplicationController
  def show
    count = picture.ratings.count.to_f
    sum = picture.ratings.all.map(&:value).inject(:+)

    render json: (sum / count)
  end
  
  private

  def gallery
    @gallery ||= Gallery.find_by_slug!(params[:slug])
  end

  def picture
    @picture ||= gallery.pictures.find(params[:id])
  end
end
