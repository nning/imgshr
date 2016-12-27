Rails.application.config.middleware.use OmniAuth::Builder do
  secrets = Rails.application.secrets
  provider :github, secrets.github_key, secrets.github_secret
end
