module Api::V1::Devise
  class PasswordsController < DeviseTokenAuth::PasswordsController
    skip_before_action :verify_authenticity_token

    def create
      generated_password = Devise.friendly_token.first(8)
      user = User.find_by_email(params[:email])

      if user&.update!(password: generated_password, password_confirmation: generated_password)
        UserMailer.with(user: user, password: generated_password).send_temporary_password.deliver
        return render_create_success
      else
        render json: { message: 'Email não encontrado.' }, status: 422
      end
    end

    protected

    def render_update_success
      resource_json_response = @resource.type == 'Client' ? resource_data.merge(address: @resource.addresses.as_json) : resource_data
      render json: resource_json_response
    end
  end
end
