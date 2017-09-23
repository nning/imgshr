module Authentication
  def self.admin?(request, session)
    Rails.env.development? ||
      Authentication::Basic.logged_in?(request) ||
      Authentication::Github.admin?(session)
  end

  def self.basic?
    !Settings.authentication.admin.github_login
  rescue
    true
  end
end
