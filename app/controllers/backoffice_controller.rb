class BackofficeController < ActionController::Base
  before_action :authenticate_admin!

  layout "backoffice/application"

  add_flash_types :info
end
