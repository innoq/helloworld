Helloworld::Application.routes.draw do

  resources :profiles do
    member do
      get :private
    end
  end
  resources :contacts

  root :to => 'home#dashboard', :as => :dashboard
  match 'header' => 'home#header', :as => :header

  match 'public/:id(.:format)' => 'profiles#show_public'

end
