module BasicAuth
  def self.authenticated?(username, password)
    username == ::Settings.authentication.username &&
      password == ::Settings.authentication.password
  end

  def self.authenticate(engine)
    engine.use Rack::Auth::Basic do |username, password|
      authenticated?(username, password)
    end
  end

  def self.logged_in?(request)
    Rails.env.development? ||
      request.authorization.present? &&
      request.authorization.split(' ').first == 'Basic'
  end
end
