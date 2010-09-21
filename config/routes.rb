Helloworld::Application.routes.draw do |map|

  resources :profiles
  resources :contacts
  resources :messages

  get "auth/login"
  get "auth/logout"
  get "auth/register"
  map.register_user 'auth/register_user', :controller => 'auth', :action => 'register_user'
  map.authenticate "auth/authenticate", :controller => 'auth', :action => 'authenticate'

  root :to => 'home#dashboard', :as => :dashboard
  match 'profile' => 'profiles#myprofile', :as => :myprofile
  match 'home/about' => 'home#about', :as => :about

  match 'public/:id(.:format)' => 'profiles#show_public'

end
