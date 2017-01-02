require 'test_helper'

class GalleriesControllerTest < ActionController::TestCase
  describe :galleries do
    it 'should create gallery, set boss token cookie, and redirect afterwards' do
      post :create
      session.detect { |k, v| k.starts_with?('boss_token_') }.wont_be_nil
      response.must_be :redirect?
    end
  end

  describe :gallery do
    subject { Gallery.create! }
    let :slug { subject.slug }

    it :show do
      get :show, params: { slug: slug }
      response.must_be :success?
    end

    it :regenerate_slug do
      post :regenerate_slug, params: { slug: slug }
      response.must_be :redirect?
    end
  end
end
