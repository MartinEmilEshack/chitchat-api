Rails.application.routes.draw do
  namespace :api do
    get :apps, to: 'apps#show'
    post :apps, to: 'apps#create'
    put :apps, to: 'apps#update'
    patch :apps, to: 'apps#update'
    delete :apps, to: 'apps#destroy'
    
    resources :apps, only: [] do
      collection do
        resources :chats, param: :num, :except => :update do
          resources :messages, param: :num, :except => :show
        end
      end
    end
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
