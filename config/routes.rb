Rails.application.routes.draw do
  namespace :api do
    resources :apps, :except => :index
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
