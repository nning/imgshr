module Authentication
  def self.admin?(request, session)
    Rails.env.development? ||
      Authentication::Basic.logged_in?(request) ||
      Authentication::Github.admin?(session)
  end
end
