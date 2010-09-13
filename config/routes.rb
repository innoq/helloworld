Helloworld::Application.routes.draw do |map|

  resources :profiles

  get "auth/login"
  get "auth/logout"
  get "auth/register"
  map.register_user 'auth/register_user', :controller => 'auth', :action => 'register_user'
  map.authenticate "auth/authenticate", :controller => 'auth', :action => 'authenticate'

  root :to => 'home#dashboard'

  match 'home' => 'home#dashboard', :as => :dashboard
  match 'home/messages' => 'home#messages', :as => :messages
  match 'home/contacts' => 'home#contacts', :as => :contacts
  match 'home/profile' => 'home#profile', :as => :myprofile
  match 'home/about' => 'home#about', :as => :about


  match 'public/:id(.:format)' => 'profiles#show_public'

end
