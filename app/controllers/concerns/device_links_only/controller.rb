module DeviceLinksOnly::Controller
  def self.included(base)
    base.class_eval do
      before_action :enforce_device_links_only, only: [:show]
      base.extend DeviceLinksOnly::Controller
    end
  end

  protected

  def enforce_device_links_only
    return if !@gallery.device_links_only || authorized?
    render status: :not_found, layout: false, file: 'public/404.html'
  end

  def authorized?
    session['boss_token_' + @gallery.slug] || 
      session['device_token_' + @gallery.slug]
  end
end
