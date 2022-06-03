Rails.application.routes.draw do
  constraints(token: /[^\/]+/) do
    namespace :api do
      resources :apps, param: :token, :except => :index
    end
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
