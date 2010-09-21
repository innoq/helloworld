Helloworld::Application.routes.draw do

  resources :profiles
  resources :contacts
  resources :messages

  get "auth/login"
  get "auth/logout"
  get "auth/register"

  match 'auth/register_user' => 'auth#register_user', :as => 'register_user'
  match 'auth/authenticate' => 'auth#authenticate', :as => 'authenticate'

  root :to => 'home#dashboard', :as => :dashboard
  match 'profile' => 'profiles#myprofile', :as => :myprofile
  match 'home/about' => 'home#about', :as => :about

  match 'public/:id(.:format)' => 'profiles#show_public'

end
