module Authentication::Github
  def self.admin?(session)
    config = Settings.authentication.admin.github_login

    return false unless config
    return false unless session['github_login']

    session['github_login'] == config
  end
end
