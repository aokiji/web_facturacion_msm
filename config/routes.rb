Tienda::Application.routes.draw do
  resources :presupuestos
  resources :facturas do
    get 'summary', on: :collection
  end
  resources :albarans
  resources :users, :only => :show
  resources :user_sessions, :only => [:new, :create, :destroy]
  
  match 'login' => 'user_sessions#new', :as => :login, via: [:get, :post]
  match 'logout' => 'user_sessions#destroy', :as => :logout, via: [:get, :post]
  match 'home' => 'users#show', :as => :home, via: [:get, :post]

  root :to => 'user_sessions#new'
end
