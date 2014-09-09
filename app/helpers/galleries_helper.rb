module GalleriesHelper
  def timeline?
    params[:action] == 'timeline'
  end
end
