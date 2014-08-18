class ContentSecurityPolicyController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :scribe

  def scribe
    render nothing: true
  end
end
