Rails.application.routes.draw do
  root to: 'galleries#new'

  get    '/!:slug' => 'galleries#show',    as: :gallery
  put    '/!:slug' => 'galleries#update'
  delete '/!:slug' => 'galleries#destroy'

  patch  '/!:slug/:id' => 'pictures#update', as: :gallery_picture
  post   '/!:slug'     => 'pictures#create'
  put    '/!:slug/:id' => 'pictures#update'

  resources :galleries, only: [:create, :index]
end
