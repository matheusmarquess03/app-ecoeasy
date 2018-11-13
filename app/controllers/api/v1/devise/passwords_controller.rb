module Api::V1::Devise
  class PasswordsController < DeviseTokenAuth::PasswordsController
    skip_before_action :verify_authenticity_token

    protected

    def render_update_success
      resource_json_response = @resource.type == 'Client' ? resource_data.merge(address: @resource.addresses.as_json) : resource_data
      render json: resource_json_response
    end
  end
end
