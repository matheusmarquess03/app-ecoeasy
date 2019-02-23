class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, if: :verify_api

  add_flash_types :info

  def verify_api
    params[:controller].split('/')[0] != 'devise_token_auth'
  end
end
