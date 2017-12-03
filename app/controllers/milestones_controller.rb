class MilestonesController < ApplicationController
  include BossTokenAble::Controller
  include SetGallery

  before_action :gallery
  before_action :enforce_read_only

  def index
  end

  def create
    @gallery.milestones.create!(milestone_params)
    redirect_to action: :index
  rescue Exception => e
    redirect_to milestones_path(@gallery), flash: { error: e.message }
  end

  def destroy
    @gallery.milestones.find(params[:id]).destroy
    redirect_to action: :index
  end

private

  def milestone_params
    params.require(:milestone).permit(:time, :description, :show_on_pictures)
  end
end
