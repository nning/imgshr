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
end
