module Api::V1::Devise
  class SessionsController < DeviseTokenAuth::SessionsController
    skip_before_action :verify_authenticity_token

    protected

    def render_create_success
      render json: resource_data(resource_json: @resource.token_validation_response)
    end
  end
end
