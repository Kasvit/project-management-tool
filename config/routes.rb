Rails.application.routes.draw do
  root 'dashboard#index'
  devise_for :users,
              path: '',
              path_names: {sign_in: 'login', sign_out: 'logout', edit: 'profile', sign_up: 'registration'},
              controllers: {omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations' }

  namespace :account do
    get '/dashboard', to: 'dashboard#index'
    resources :workspaces do
      resources :projects, except: [:index]
    end

    resources :projects, only: [] do
      resources :tasks, except: [:index] do
        member do
          put :move
          patch :watch
          get :choose_assignee
          post :assign
          delete :unassign
          delete :remove_attachment
        end
      end
    end
  end
end
