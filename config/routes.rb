Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :apps, param: :token do
        resources :chats, param: :num, except: :update do
          resources :messages, param: :num, except: :show
        end
      end
    end
  end
end
