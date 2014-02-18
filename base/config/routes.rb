Helloworld::Application.routes.draw do

  get '/' => 'home#json_home', :as => :root
  put '/' => 'home#register_resources'
  get '/home/about' => 'home#about', :as => :about
  get 'header' => 'home#header', :as => :header

  get "auth/login"
  get "auth/logout"
  get "auth/register"

  post 'auth/register_user' => 'auth#register_user', :as => 'register_user'
  post 'auth/authenticate' => 'auth#authenticate', :as => 'authenticate'

end
