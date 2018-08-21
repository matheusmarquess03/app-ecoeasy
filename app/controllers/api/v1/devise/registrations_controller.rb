module Api::V1::Devise
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    skip_before_action :verify_authenticity_token
    before_action :configure_permitted_parameters

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(
          :sign_up,
          keys:[
            :email, :password, :password_confirmation, :access_profile, :name, :cpf, :phone_number
          ]
      )
    end
  end
end
