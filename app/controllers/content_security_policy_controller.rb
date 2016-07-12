class ContentSecurityPolicyController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :scribe

  def scribe
    head :ok
  end
end
