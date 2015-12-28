Tienda::Application.routes.draw do
  resources :presupuestos
  resources :facturas
  resources :albarans
  resources :users, :only => :show
  resources :user_sessions, :only => [:new, :create, :destroy]
  
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'home' => 'users#show', :as => :home

  root :to => 'user_sessions#new'
end
