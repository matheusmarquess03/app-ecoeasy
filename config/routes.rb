Rails.application.routes.draw do
  namespace :backoffice do
    get '', to: 'dashboard#index'

    resources :truckers
  end

  devise_for :users



end
