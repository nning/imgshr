Rails.application.routes.draw do
  root to: 'galleries#new'

  get    '/!:slug' => 'galleries#show',    as: :gallery
  put    '/!:slug' => 'galleries#update'
  delete '/!:slug' => 'galleries#destroy'

  get    '/!:slug/timeline' => 'galleries#timeline', as: :gallery_timeline

  get    '/!:slug/:id' => 'galleries#show',  as: :gallery_picture
  patch  '/!:slug/:id' => 'pictures#update'
  post   '/!:slug'     => 'pictures#create'
  put    '/!:slug/:id' => 'pictures#update'

  get    '/!:slug/:id/download' => 'pictures#download', as: :gallery_picture_download

  resources :galleries, only: [:create, :index]
end
