Rails.application.routes.draw do
  ## Routes to Users - using Devise Token Auth
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth',
        controllers: { registrations: 'api/v1/devise/registrations' }
    end
  end

  ## Routes to Admins
  # Devise redirects configurations
  devise_for :admins, controllers: { sessions: 'devise/admins/sessions' }

  # Routes to Backoffice portal (admin)
  namespace :backoffice do
    get '', to: 'dashboard#index'

    resources :truckers
  end

end
