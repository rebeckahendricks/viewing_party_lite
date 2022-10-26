Rails.application.routes.draw do
  get '/', to: 'landing#index'

  get '/register', to: 'users#new'
  get '/login', to: 'users#login_form'
  post '/login', to: 'users#login'
  post '/', to: 'users#logout'
  get '/dashboard', to: 'users#show'
  post '/users', to: 'users#create'

  get '/discover', to: 'discover#index'

  resources :movies, only: [:index, :show] do
    resources :viewing_party, only: [:new, :create]
  end
end