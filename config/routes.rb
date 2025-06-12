Rails.application.routes.draw do
  get "notifications/index"
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :posts do
    resources :comments, only: [:create, :destroy]
    member do
      post :like
      delete :unlike
    end
  end

  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create, :destroy]
  end

  resources :notifications, only: [:index]

  get 'about', to: 'pages#about'
  root 'posts#index'

  get 'profile/edit', to: 'profiles#edit', as: :edit_profile
  get 'profile(/:id)', to: 'profiles#show', as: :profile
  patch 'profile', to: 'profiles#update'

  # Route for deleting Active Storage attachments
  resources :active_storage_attachments, only: [:destroy]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
