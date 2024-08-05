module Authentication::Github
  def self.admin?(session)
    config = Settings.authentication.admin.github_login

    return false unless config
    return false unless session['github_login']

    session['github_login'] == config
  end

  def self.login?(session)
    config = Settings.authentication.admin.github_login
    user = session['github_login']

    return false unless config
    return false unless user

    self.allowed_github_user?(user)
  end

  private def self.allowed_github_user?(login)
    if !Settings.authentication.allowed_github_users.is_a?(Array)
      return true
    end

    Settings.authentication.allowed_github_users.include?(session['github_login'])
  end
end
