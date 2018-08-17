module Devise::Admins
  class SessionsController < Devise::SessionsController
    protected
    def after_sign_in_path_for(resources)
      backoffice_path
    end

    def after_sign_out_path_for(resources)
      new_admin_session_path
    end
  end
end
