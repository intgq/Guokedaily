Rails.application.routes.draw do
  resources :relationships
  resources :microposts
  get 'users/_follow_form'
  get 'users/_follow'
  get 'users/_form'
  get 'users/_unfollow'
  get 'users/_user'
  get 'users/edit'
  get 'users/index'
  get 'users/new'
  get 'users/show_follow'
  get 'users/show'
  get 'user_mailer/account_activation'
  get 'sessions/new'
  get 'relationships/create'
  get 'relationships/destroy'
  get 'microposts/_micropost'
  get 'share/_error_messages'
  get 'share/_feed'
  get 'share/_micropost_form'
  get 'share/_stats'
  get 'share/_user_info'
  get 'static_pages/home'
   # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
   root 'static_pages#home'
   resources :users
   resources :account_activations, only: [:edit]
   resources :microposts, only: [:create, :destroy]
 
   resources :users do
     member do
       get :following, :followers
     end
   end
   resources :relationships, only: [:create, :destroy]
 
   get '/login', to: 'sessions#new'
   post '/login', to: 'sessions#create'
   get 'logout', to: 'sessions#destroy'
  
end
