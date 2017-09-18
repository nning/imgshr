module Authentication::Basic
  def self.authenticated?(username, password)
    auth_config = ::Settings.authentication.admin

    return false unless auth_config

    username == auth_config.username &&
      password == auth_config.password
  end

  def self.authenticate(engine)
    engine.use Rack::Auth::Basic do |username, password|
      authenticated?(username, password)
    end
  end

  def self.logged_in?(request)
    request.authorization.present? &&
      request.authorization.split(' ').first == 'Basic'
  end
end
