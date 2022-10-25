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

# root 'welcome#index'

#   get '/register', to: 'users#new'
#   post '/users', to: 'users#create'
#   get '/movies', to: 'movies#index', as: 'movies'
#   get '/movies/:id', to: 'movies#show', as: 'movie'
#   get '/login', to: "users#login_form"
#   post '/login', to: "users#login_user"
#   get '/dashboard', to: "users#show"
