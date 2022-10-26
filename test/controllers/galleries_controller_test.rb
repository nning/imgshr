require 'test_helper'

class GalleriesControllerTest < ActionController::TestCase
  describe :galleries do
    it 'should create gallery, set boss token cookie, and redirect afterwards' do
      post :create
      _(session.detect { |k, v| k.starts_with?('boss_token_') }).wont_be_nil
      _(response).must_be :redirect?
    end

    it 'should create gallery with github uid' do
      r = rand(1..2**10)
      session['github_uid'] = r
      post :create
      _(Gallery.last.boss_token.github_uid).must_equal r
      _(session.detect { |k, v| k.starts_with?('boss_token_') }).wont_be_nil
      _(response).must_be :redirect?
    end

    it 'should not index if unauthorized' do
      get :index
      _(response.status).must_equal 401
    end

    it 'should index if authorized (http basic)' do
      AUTH = Settings.authentication.admin
      request.headers['Authorization'] =
        ActionController::HttpAuthentication::Basic
          .encode_credentials(AUTH.username, AUTH.password)

      get :index
      _(response).must_be :successful?
    end
  end

  describe :gallery do
    subject { Gallery.create! }
    let(:slug) { subject.slug }

    it :show do
      get :show, params: { slug: slug }
      _(response).must_be :successful?
    end

    it :regenerate_slug do
      post :regenerate_slug, params: { slug: slug }
      _(response).must_be :redirect?
    end

    it 'should update name if not read-only' do
      put :update, params: { slug: slug, gallery: { name: 'foo' } }
      _(response).must_be :successful?
    end

    it 'should not update name if read-only' do
      subject.update!(read_only: true)

      put :update, params: { slug: slug, gallery: { name: 'foo' } }
      _(response.status).must_equal 403
    end

    it 'should not update attributes if boss token unavailable' do
      put :update, params: {
        slug: slug,
        gallery: {
          endless_page: false,
          ratings_enabled: false,
          read_only: true,
          device_links_only: true
        }
      }

      _(response).must_be :successful?

      subject.reload
      _(subject.endless_page).must_equal true
      _(subject.ratings_enabled).must_equal true
      _(subject.read_only).must_equal false
      _(subject.device_links_only).must_equal false
    end

    it 'should update attributes if boss token available' do
      session['boss_token_' + slug] = subject.boss_token.slug

      put :update, params: {
        slug: slug,
        gallery: {
          endless_page: false,
          ratings_enabled: false,
          read_only: true,
          device_links_only: true
        }
      }

      _(response).must_be :successful?

      subject.reload
      _(subject.endless_page).must_equal false
      _(subject.ratings_enabled).must_equal false
      _(subject.read_only).must_equal true
      _(subject.device_links_only).must_equal true
    end
  end
end
