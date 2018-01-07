# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.config.content_security_policy do |p|
  if Rails.env.production?
    p.default_src :self, :https
    p.font_src    :self, :https, :data
    p.img_src     :self, :https, :data          # data: client encryption
    p.object_src  :none
    p.script_src  :self, :https, :unsafe_eval   # unsafe_eval: endless scrolling
    p.style_src   :self, :https, :unsafe_inline # unsafe_inline: ratings
  else
    p.default_src :self, :http
    p.font_src    :self, :http, :data
    p.img_src     :self, :http, :data
    p.object_src  :none
    p.script_src  :self, :http, :unsafe_eval
    p.style_src   :self, :http, :unsafe_inline
  end

  # Specify URI for violation reports
  # p.report_uri "/csp-violation-report-endpoint"
end

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
