Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  ## Routes to Users - using Devise Token Auth
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth',
        controllers: {
          registrations: 'api/v1/devise/registrations',
          sessions:      'api/v1/devise/sessions',
          passwords:     'api/v1/devise/passwords'
        }

      resources :clients, only: [] do
        collection do
          get 'already_registered'
          get 'session_active'
          get 'search'
        end
      end

      devise_scope :user do
        resources :address,   only: [:index, :create, :update, :destroy]
        resource  :schedules, only: [:show, :update]
        resources :collects,  only: [:index, :create, :update]
        put 'dump_collects', to: 'collects#dump_collects'

        resources :trucks,        only: [:index]
        resources :evidences,     only: [:create, :index]
        resources :infringements, only: [:index] do
          resources :contestations, only: [:create, :index]
        end
        resource  :routes,        only: [:show]
        resources :landfills,     only: [:index]
        resources :contracts
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
      resources :rubble_collects do
        get 'reports', on: :collection
      end

      resources :daily_garbage_collects do
        get 'reports', on: :collection
      end
    end

    get 'rubble_collects/trucker_tracking', to: 'collects/rubble_collects#trucker_tracking'
    get 'daily_garbage_collects/trucker_tracking', to: 'collects/daily_garbage_collects#trucker_tracking'

    resources :routes
    resources :infringements, only: [:index, :show]
    namespace :evidences do
      resources :simple_evidences, only: [:index, :show, :update, :edit]
      resources :incidents,        only: [:index, :show, :update, :edit]
    end
    resources :trucks
    resources :landfills
    resources :contracts do
      member do
        delete :destroy_attachment
      end
    end
  end
end
