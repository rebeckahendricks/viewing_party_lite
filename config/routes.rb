Rails.application.routes.draw do
  get '/', to: 'landing#index'

  match 'register', via: :get, to: 'users#new'
  resources :users, only: [:show, :create]
end