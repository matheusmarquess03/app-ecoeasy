# frozen_string_literal: true

class BackofficeController < ActionController::Base
  before_action :authenticate_admin!
  around_action :handle_exception
  after_action :clear_flash

  layout "backoffice/application"

  add_flash_types :info

  private

  def handle_exception
    yield
  rescue ActiveRecord::InvalidForeignKey
    flash[:alert] = I18n.t('genrical_errors.forbidden_destroy')
    redirect_back fallback_location: backoffice_path
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = I18n.t('genrical_errors.not_found')
    redirect_back fallback_location: backoffice_path
  rescue StandardError
    flash[:alert] = I18n.t('genrical_errors.internal_error')
    redirect_back fallback_location: backoffice_path
  end

  def clear_flash
    flash.discard
  end
end
