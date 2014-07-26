Rails.application.routes.draw do
  root to: 'galleries#new'

  get '/!:slug' => 'galleries#show', as: :gallery
  put '/!:id' => 'galleries#update'

  resources :galleries, only: [:create, :index] do
    resources :pictures, on: :collection, only: [:create]
  end
end
