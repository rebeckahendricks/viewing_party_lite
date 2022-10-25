Rails.application.routes.draw do
  get '/', to: 'landing#index'
  post '/', to: 'users#logout'

  get '/register', to: 'users#new'
  get '/login', to: 'users#login_form'
  post '/login', to: 'users#login'
  get '/dashboard', to: 'users#show'

  resources :users, only: [:create] do
    resources :discover, only: [:index]
    resources :movies, only: [:index, :show] do
      resources :viewing_party, only: [:new, :create]
    end
  end
end
