class ApplicationController < ActionController::Base
 before_action :configure_permitted_parameters, if: :devise_controller?	
  protect_from_forgery with: :exception, if: :verify_api

  add_flash_types :info

  def configure_permitted_parameters
    # Permit the `subscribe_newsletter` parameter along with the other
    # sign up parameters.
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :remember_me])
  end

  def verify_api
    params[:controller].split('/')[0] != 'devise_token_auth'
  end
end
