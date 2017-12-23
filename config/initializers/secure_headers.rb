::SecureHeaders::Configuration.default do |config|
  config.hsts = 'max-age=%s; includeSubDomains' % 20.years.to_i
  config.x_frame_options = 'DENY'
  config.x_content_type_options = 'nosniff'
  config.x_xss_protection = '1; mode=block'
  config.referrer_policy = 'origin'

  if Rails.env.production?
    config.csp = {
      default_src:  %w[https: 'self'],
      script_src:   %w[https: 'self' 'unsafe-eval'],
      style_src:    %w[https: 'self' 'unsafe-inline'],
      img_src:      %w[https: 'self' data:],
      report_uri:   %w[/content_security_policy/forward_report]
    }
  else
    # config.csp = SecureHeaders::OPT_OUT
    config.csp = {
      default_src:  %w['self' 0.0.0.0:3001 localhost:3001 localhost:3035],
      script_src:   %w['self' 0.0.0.0:3001 localhost:3001 localhost:3035 'unsafe-eval'],
      style_src:    %w['self' 'unsafe-inline'],
      img_src:      %w['self' data:],
      report_uri:   %w[/content_security_policy/forward_report]
    }
  end
end
