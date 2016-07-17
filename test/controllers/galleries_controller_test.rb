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

    it :show do
      get :show, params: { slug: subject.slug }
      response.must_be :success?
    end

    it :new_slug do
      post :new_slug, params: { slug: subject.slug }
      response.must_be :redirect?
    end
  end
end
