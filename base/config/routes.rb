Helloworld::Application.routes.draw do

  get '/' => 'home#dashboard', :as => :dashboard
  put '/' => 'home#register_resources'
  get '/home/about' => 'home#about', :as => :about
  get 'header' => 'home#header', :as => :header

  get "auth/login"
  get "auth/logout"
  get "auth/register"

  get 'auth/register_user' => 'auth#register_user', :as => 'register_user'
  get 'auth/authenticate' => 'auth#authenticate', :as => 'authenticate'

end
