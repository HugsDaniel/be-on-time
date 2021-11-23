Rails.application.routes.draw do
  get 'trips/show'
  get 'buses/show'
  get 'itineraries/index'
  get 'itineraries/show'
  get 'itineraries/favorites'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :itineraries, only: %i[index show] do
    member do
      patch :mark_as_favorite
    end

    collection do
      get :favorites
    end
  end

  resources :buses, only: %i[show update]

  resources :trips, only: %i[create show] do
    member do
      patch :completed
    end
  end
end
