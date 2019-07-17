Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help', :to => 'static_pages#help'
  get '/about', :to => 'static_pages#about'
  get '/contact', :to => 'static_pages#contact'

  get '/signup', :to => 'users#new'
  post '/signup', :to => 'users#create'

  get '/login', :to => 'sessions#new'
  post '/login', :to => 'sessions#create'
  delete '/logout', :to => 'sessions#destroy'

  get '/fixtures', :to => 'matches#fixtures'
  get '/results', :to => 'matches#results'

  get '/bids', :to => 'players#bids'

  resources :players
  resources :premier_league_teams

  resources :teams do
    resources :bids, :shallow => true
  end

  resources :leagues
  resources :matches

  resources :users

  resources :account_activations, :only => %i[edit]
  resources :password_resets, :only => %i[new create edit update]
end
