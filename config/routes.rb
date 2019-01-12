Rails.application.routes.draw do
  ## Routes to Users - using Devise Token Auth
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth',
        controllers: {
          registrations: 'api/v1/devise/registrations',
          sessions:      'api/v1/devise/sessions',
          passwords:     'api/v1/devise/passwords'
        }

      get 'client/already_registred', to: 'clients#already_registered?'
      get 'client/session_active',    to: 'clients#user_session_active?'

      devise_scope :user do
        resources :address,   only: [:index, :create, :update, :destroy]
        resource  :schedules, only: [:show, :update]
        resources :collects,  only: [:index, :create, :update]
        put 'dump_collects', to: 'collects#dump_collects'

        resources :trucks,    only: [:index]
        resources :evidences, only: [:create, :index]
        resource  :routes,    only: [:show]
        resources :landfills, only: [:index]
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
    resources :janitors
    resources :supervisors do
      get 'tracking', on: :collection
    end
    resources :clerks
    resources :schedules
    namespace :collects do
      resources :rubble_collects
      resources :daily_garbage_collects
    end
    get 'rubble_collects/trucker_tracking', to: 'collects/rubble_collects#trucker_tracking'
    get 'daily_garbage_collects/trucker_tracking', to: 'collects/daily_garbage_collects#trucker_tracking'

    resources :routes
    namespace :evidences do
      resources :simple_evidences, only: [:index, :show]
      resources :incidents,        only: [:index, :show]
    end
    resources :trucks
    resources :landfills
  end
end
