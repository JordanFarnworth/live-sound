Rails.application.routes.draw do

  scope :api, defaults: { format: :json }, constraints: { format: :json } do
    scope :v1 do
      concern :entity_context do
        resources :event_applications
        resources :event_invitations
        resources :favorites
        resources :notifications
        resources :reviews
        resources :entity_users
        resources :events, only: [:index, :show, :create, :update, :destroy], shallow: true
      end
      post 'login' => 'sessions#verify'
      get 'current_user' => 'sessions#logged_in_user'
      get 'current_entities' => 'sessions#current_entities'
      resources :users, concerns: [:entity_context] do
        member do
          post 'update' => 'users#update'
        end
      end
      resources :bands, concerns: [:entity_context]
      resources :enterprises, concerns: [:entity_context]
      resources :private_parties, concerns: [:entity_context]
      resources :events, only: [:index]
    end
  end

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
