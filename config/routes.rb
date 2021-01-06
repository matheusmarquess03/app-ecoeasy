# frozen_string_literal: true

# Routes
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
        resources :address,   only: %i[index create update destroy]
        resource  :schedules, only: %i[show update]
		resources  :routes,	  only: %i[index]
        resources :collects,  only: %i[index create update]
        put 'dump_collects', to: 'collects#dump_collects'

        resources :trucks, only: [:index]
        resources :evidences, only: %i[create index update]
        resources :infringements, only: %i[index show] do
          get 'send_bill_to_email', on: :member
          resources :contestations, only: %i[create index]
        end
        resources :routes,		  only: [:show]
        resources :landfills,     only: [:index]
        resources :contracts
      end
    end
  end

  ## Routes to Admins
  # Devise redirects configurations
  devise_for :admins, controllers: {
    sessions: 'devise/admins/sessions',
    registrations: 'devise/admins/registrations'
  }

  # Routes to Backoffice portal (admin)
  namespace :backoffice do
    get '', to: 'dashboard#index'

	#get '', to: 'dashboard_principal#index'

	resources :firebase_data
	
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
        get 'change_status', on: :member
      end

      resources :daily_garbage_collects do
        get 'reports', on: :collection
        get 'change_status_form', on: :member
        patch 'change_status', on: :member
      end
	  
	  resources :daily_garbage_history do
		get 'change_status_form', on: :member
        patch 'change_status', on: :member
      end
	  
	end

	get 'dashboard/trucker_analysis', to: 'dashboard#trucker_analysis'
	get 'dashboard/truck_analysis', to: 'dashboard#truck_analysis'
	get 'dashboard/route_analysis', to: 'dashboard#route_analysis'
	
	get 'daily_garbage_history/reports', to: 'collects/daily_garbage_history#reports'
	
    get 'rubble_collects/trucker_tracking', to: 'collects/rubble_collects#trucker_tracking'
    get 'daily_garbage_collects/trucker_tracking', to: 'collects/daily_garbage_collects#trucker_tracking'

    resources :routes
    resources :infringements, only: %i[index show update]
    resources :evidences,     only: :index do
      resources :comments,    only: %i[create destroy]
    end

    namespace :evidences do
      resources :simple_evidences, only: %i[index show update edit]
      resources :incidents,        only: %i[index show update edit]
    end

    resources :trucks
    resources :landfills
    resources :contracts do
      member do
        delete :destroy_attachment
      end
    end

    resources :configurations, only: [:index]
    resources :template_contestations, except: [:show]
  end

  
  get 'home/index'
  root 'backoffice/dashboard#index'
end




