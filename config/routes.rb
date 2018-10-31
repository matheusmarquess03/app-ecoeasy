Rails.application.routes.draw do
  ## Routes to Users - using Devise Token Auth
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth',
        controllers: {
          registrations: 'api/v1/devise/registrations',
          sessions:      'api/v1/devise/sessions'
        }

      get 'client/already_registred', to: 'clients#already_registered?'
      get 'client/session_active',    to: 'clients#user_session_active?'

      devise_scope :user do
        resources :address,   only: [:create, :update, :index]
        resource  :schedules, only: [:show]
        resources :collects,  only: [:index, :create, :update]
        resource  :evidences, only: [:create]
      end
    end
  end

  ## Routes to Admins
  # Devise redirects configurations
  devise_for :admins, controllers: { sessions: 'devise/admins/sessions' }

  # Routes to Backoffice portal (admin)
  namespace :backoffice do
    get '', to: 'dashboard#index'

    resources :truckers
    resources :schedules
    resources :collects
  end
end
