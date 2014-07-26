Rails.application.routes.draw do
  root to: 'galleries#new'

  get    '/!:slug' => 'galleries#show',    as: :gallery
  put    '/!:id'   => 'galleries#update'
  delete '/!:id'   => 'galleries#destroy'

  resources :galleries, only: [:create, :index] do
    resources :pictures, on: :collection, only: [:create, :update]
  end
end
