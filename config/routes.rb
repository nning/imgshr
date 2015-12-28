Rails.application.routes.draw do
  require 'sidekiq/web'

  unless Rails.env.development?
    BasicAuth.authenticate Sidekiq::Web
    BasicAuth.authenticate RedisBrowser::Web
  end

  mount Sidekiq::Web => '/sidekiq'
  mount RedisBrowser::Web => '/redis'

  root to: 'galleries#new'

  get    '!:slug' => 'galleries#show', as: :gallery
  put    '!:slug' => 'galleries#update'
  delete '!:slug' => 'galleries#destroy'

  get    '!:slug/timeline' => 'galleries#timeline', as: :gallery_timeline

  get    '-:token' => 'boss_tokens#show', as: :gallery_delete
  delete '-:token' => 'boss_tokens#destroy'

  delete '-:token/:id' => 'boss_tokens#destroy_picture',
    as: :gallery_picture_delete

  patch  '!:slug/:id' => 'pictures#update', as: :gallery_picture
  post   '!:slug'     => 'pictures#create'
  put    '!:slug/:id' => 'pictures#update'

  get    '!:slug(/tags/:tags)(/time/:since(/:until))(/stars/:min_rating(/:max_rating))' => 'galleries#show',
    as: :gallery_filter

  get    '!:slug/:id/rating' => 'ratings#show', as: :picture_rating
  post   '!:slug/:id/rating' => 'ratings#create'

  get    '!:slug/:id/download' => 'pictures#download',
    as: :gallery_picture_download

  get    '+:fingerprint' => 'pictures#show', as: :picture

  get    '~:slug' => 'pictures#temp_link', as: :temp_link

  post   'content_security_policy/forward_report',
    to: 'content_security_policy#scribe'

  resources :galleries, only: [:create, :index]
end
