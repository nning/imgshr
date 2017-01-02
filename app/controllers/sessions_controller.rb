class SessionsController < ApplicationController
  def new
    redirect_to '/auth/github'
  end

  def create
    session['github_uid']   = request.env['omniauth.auth'].uid
    session['github_login'] = request.env['omniauth.auth'].info.nickname

    redirect_to root_url, flash: {
      notice: 'Authenticated via GitHub as "%s" successfully!' % session['github_login']
    }
  end

  def destroy
    session.delete('github_uid')
    session.delete('github_login')

    redirect_to root_url, flash: {
      notice: 'Signed out successfully!'
    }
  end

  def failure
    redirect_to root_url, flash: {
      error: 'Authentication error: %s' % params[:message].humanize
    }
  end
end
