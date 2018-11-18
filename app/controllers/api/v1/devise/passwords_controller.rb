module Api::V1::Devise
  class PasswordsController < DeviseTokenAuth::PasswordsController
    skip_before_action :verify_authenticity_token

    def create
      generated_password = Devise.friendly_token.first(8)
      current_user = User.find_by_email(params[:email])

      if current_user.present?
        current_user.update!(password: generated_password, password_confirmation: generated_password)
        UserMailer.with(user: current_user, password: generated_password).send_temporary_password.deliver
        render json: { message: 'Você receberá um e-mail com instruções sobre como redefinir sua senha.' }, status: 200
      else
        render json: { message: 'Email não encontrado.' }, status: 422
      end
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    protected

    def render_update_success
      resource_json_response = @resource.type == 'Client' ? resource_data.merge(address: @resource.addresses.as_json) : resource_data
      render json: resource_json_response
    end
  end
end
