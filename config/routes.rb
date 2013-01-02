CardTracker::Application.routes.draw do
  devise_for :users #, :only => [:sessions, :passwords]

  devise_scope :user do
    get '/login' => 'devise/sessions#new', :as => 'login'
    delete '/logout' => 'devise/sessions#destroy', :as => 'logout'
    get '/reset-password' => 'devise/passwords#new', :as => 'reset_password'
  end

  get '/contact' => 'contact#new', :as => 'contact'

  post '/contact' => 'contact#create'

  resource :collection

  resources :card_sets, :path => :sets, :as => :sets, :only => [:index] do
    resources :cards, :only => [:index, :show]
  end

  authenticate :user do
    namespace :admin do
      root :to => 'admin#index'

      resource :account, :only => [:show, :edit, :update]

      resources :cards

      resources :card_sets

      resources :card_blocks

      resources :card_block_types

      resources :users
    end
  end

  root :to => 'collections#show'
end
