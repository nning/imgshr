Rails.application.routes.draw do
  require 'sidekiq/web'

  unless Rails.env.development?
    Authentication::Basic.authenticate Sidekiq::Web
  end

  mount Sidekiq::Web => '/sidekiq'

  root to: 'galleries#new'

  get    '!:slug' => 'galleries#show', as: :gallery
  put    '!:slug' => 'galleries#update'
  delete '!:slug' => 'galleries#destroy'
  get    'api/!:slug' => 'galleries#show', defaults: { format: :json }

  get    '!:slug/timeline' => 'galleries#timeline', as: :gallery_timeline

  post   '!:slug/regenerate_slug' => 'galleries#regenerate_slug', as: :gallery_regenerate_slug
  post   '!:slug/create_device_link' => 'galleries#create_device_link', as: :gallery_create_device_link

  get    '!:slug/milestones' => 'milestones#index', as: :milestones
  post   '!:slug/milestones' => 'milestones#create', as: :milestone
  delete '!:slug/milestones' => 'milestones#destroy'

  get    '-:token' => 'boss_tokens#show', as: :gallery_delete
  delete '-:token' => 'boss_tokens#destroy'

  delete '-:token/:id' => 'boss_tokens#destroy_picture',
    as: :gallery_picture_delete
  delete '-:token/pictures/multi-delete' => 'boss_tokens#destroy_multiple_pictures',
    as: :gallery_multiple_pictures_delete

  get    '!:slug/:fingerprint' => 'pictures#gallery_show', as: :gallery_picture
  patch  '!:slug/:id'          => 'pictures#update'
  post   '!:slug'              => 'pictures#create'
  post   'api/!:slug'          => 'pictures#api_create'
  put    '!:slug/:id'          => 'pictures#update'

  get    '!:slug(/tags/:tags)(/time/:since(/:until))(/stars/:min_rating(/:max_rating))' => 'galleries#show',
    as: :gallery_filter

  get    '!:slug/:id/rating' => 'ratings#show', as: :picture_rating
  post   '!:slug/:id/rating' => 'ratings#create'

  get    '+:fingerprint' => 'pictures#show', as: :picture

  get    '=:slug' => 'temp_links#show', as: :temp_link
  post   '!:slug/:id/temp_link' => 'temp_links#create', as: :temp_link_create

  get    '~:slug' => 'galleries#device_link', as: :device_link

  post   'content_security_policy/forward_report',
    to: 'content_security_policy#scribe'

  resources :galleries, only: [:create, :index]
  get 'galleries/pictures' => 'pictures#index', as: :picture_feed, defaults: { format: :atom }

  resources :file_releases, only: [:create, :index], path: :releases

  get 'auth/:provider/callback' => 'sessions#create'
  get 'login' => 'sessions#new', as: :login
  get 'logout' => 'sessions#destroy', as: :logout
  get 'auth/failure' => 'sessions#failure'
end
