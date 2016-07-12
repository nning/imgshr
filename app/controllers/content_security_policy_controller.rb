class ContentSecurityPolicyController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :scribe

  def scribe
    head :ok
  end
end
