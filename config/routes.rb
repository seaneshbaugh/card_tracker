CardTracker::Application.routes.draw do
  devise_for :users, :skip => [:sessions, :passwords, :registrations, :confirmations, :unlocks]

  devise_scope :user do
    get 'login' => 'devise/sessions#new', :as => :new_user_session
    post 'login' => 'devise/sessions#create', :as => :user_session
    delete 'logout' => 'devise/sessions#destroy', :as => :destroy_user_session

    post 'update-password' => 'devise/passwords#create', :as => :user_password
    get 'reset-password' => 'devise/passwords#new', :as => :new_user_password
    get 'update-password' => 'devise/passwords#edit', :as => :edit_user_password
    put 'update-password' => 'devise/passwords#update'

    post 'register' => 'devise/registrations#create', :as => :user_registration
    get 'register' => 'devise/registrations#new', :as => :new_user_registration

    post 'confirm-registration' => 'devise/confirmations#create', :as => :user_confirmation
    get 'resend-confirmation' => 'devise/confirmations#new', :as => :new_user_confirmation
    get 'confirm-registration' => 'devise/confirmations#show'

    post 'unlock-account' => 'devise/unlocks#create', :as => :user_unlock
    get 'resend-unlock' => 'devise/unlocks#new', :as => :new_user_unlock
    get 'unlock-account' => 'devise/unlocks#show'
  end

  get '/contact' => 'contact#new', :as => 'contact'

  post '/contact' => 'contact#create'

  resources :card_lists, :path => 'lists', :as => :lists do
    collection do
      put 'order' => 'card_lists#reorder', :as => :reorder
    end

    resources :card_sets, :path => :sets, :as => :sets, :only => [:index] do
      resources :cards, :only => [:index, :show]
    end
  end

  resources :card_sets, :path => :sets, :as => :sets, :only => [:index] do
    resources :cards, :only => [:index, :show]
  end

  put '/collection/quantity' => 'collections#update_quantity'

  put '/collection/card_list' => 'collections#move_card_list'

  get '/cards/search' => 'cards#search', :as => 'card_search'

  resources :stats, :only => [:index, :show]

  resource :account, :only => [:show, :edit, :update, :destroy] do
    member do
      get 'confirm-delete' => 'accounts#confirm_delete', :as => :confirm_delete
    end
  end

  authenticate :user do
    namespace :admin do
      root :to => 'admin#index'

      resources :cards

      resources :card_sets

      resources :card_blocks

      resources :card_block_types

      resources :users
    end
  end

  authenticated do
    root :to => 'card_lists#index'
  end

  root :to => 'pages#index'

  match ':id' => 'pages#show'
end
