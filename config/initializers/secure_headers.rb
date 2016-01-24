::SecureHeaders::Configuration.default do |config|
  config.hsts = 'max-age=%s; includeSubDomains' % 20.years.to_i
  config.x_frame_options = 'DENY'
  config.x_content_type_options = 'nosniff'
  config.x_xss_protection = '1; mode=block'

  if Rails.env.production?
    config.csp = {
      enforce:      true,
      default_src:  %w[https: 'self'],
      script_src:   %w[https: 'self' 'unsafe-eval'],
      style_src:    %w[https: 'self' 'unsafe-inline'],
      report_uri:   %w[/content_security_policy/forward_report]
    }
  else
    config.csp = {
      enforce:      true,
      default_src:  %w['self'],
      script_src:   %w['self' 'unsafe-eval'],
      style_src:    %w['self' 'unsafe-inline'],
      report_uri:   %w[/content_security_policy/forward_report]
    }
  end
end
