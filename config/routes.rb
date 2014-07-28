Rails.application.routes.draw do
  root to: 'galleries#new'

  get    '/!:slug' => 'galleries#show',    as: :gallery
  put    '/!:slug' => 'galleries#update'
  delete '/!:slug' => 'galleries#destroy'

  patch  '/!:slug/:id' => 'pictures#update', as: :picture
  put    '/!:slug/:id' => 'pictures#update'

  resources :galleries, only: [:create, :index] do
    resources :pictures, on: :collection, only: :create
  end
end
