Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  resource :session, only: [:new, :create, :destroy]
  root 'breweries#index'
  #get 'kaikki_bisset', to: 'beers#index'
  #get 'ratings', to: 'ratings#index'
  #get 'ratings/new', to:'ratings#new'
  resources :ratings, only: [:index, :new, :create, :destroy]
  resources :places, only:[:index, :show]
  post 'places', to:'places#search'
  post 'ratings', to: 'ratings#create'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  get 'places', to: 'places#index'
  delete 'signout', to: 'sessions#destroy'

end
