::SecureHeaders::Configuration.configure do |config|
  config.hsts = {max_age: 20.years.to_i, include_subdomains: true}
  config.x_frame_options = 'DENY'
  config.x_content_type_options = 'nosniff'
  config.x_xss_protection = {value: 1, mode: 'block'}

  if Rails.env.production?
    config.csp = {
      enforce:      true,
      default_src:  "https: 'self'",
      script_src:   "https: 'self' 'unsafe-eval'",
      style_src:    "https: 'self' 'unsafe-inline'",
      report_uri:   '/content_security_policy/forward_report'
    }
  else
    config.csp = {
      enforce:      true,
      default_src:  "'self'",
      script_src:   "'self' 'unsafe-eval'",
      style_src:    "'self' 'unsafe-inline'",
      report_uri:   '/content_security_policy/forward_report'
    }
  end
end
