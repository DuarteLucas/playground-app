Rails.application.routes.draw do


  devise_for :users,
   controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: "registrations" }

  root to: 'pages#home'

  resources :lists do
    get '/welcome_new', on: :collection, to: 'lists#welcome_new'
    resources :movies, only: [:new, :create]
    get '/search', to: 'movies#search'
    get '/search_results', to: 'movies#search_results'


    get '/add_movie', to: 'movie_lists#add_movie'
    delete '/remove_movie', to: 'movie_lists#remove_movie'

  end

  get '/search', to: 'application#search'
  get '/search_results', to: 'application#search_results'

  resources :movies, only: [:show, :index, :new, :create]
  resources :users, only: [:show]

  # route to create a user to user following relationship (followship)
  resources :followships, only: [:create] do
    delete "/", to: 'followships#destroy', on: :collection
  end



  get '/dashboard', to: 'pages#dashboard'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
