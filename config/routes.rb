Rails.application.routes.draw do

  scope :api, defaults: { format: :json }, constraints: { format: :json } do
    scope :v1 do
      concern :entity_context do
        resources :event_applications
        resources :event_memberships, only: [:index]
        resources :favorites, only: [:index, :create, :destroy], shallow: true do
          get :mine, on: :collection
        end
        resources :favorites
        resources :notifications, only: [:index, :show, :create, :update]
        resources :reviews
        resources :entity_users
        resources :events, only: [:index, :create, :update, :destroy], shallow: true
        resources :messages, only: [:index, :destroy, :show, :create] do
          member do
            post :mark_as_read
            delete :remove_messages
          end
        end
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
      resources :events, only: [:index, :show, :update] do
        resources :event_memberships, only: [:create, :index, :update, :destroy], shallow: true
      end
      resources :events, only: [:index]
      resources :bands, concerns: [:entity_context]
      resources :enterprises, concerns: [:entity_context]
      resources :private_parties, concerns: [:entity_context]
    end
  end

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
