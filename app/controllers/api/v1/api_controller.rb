module Api::V1
  class ApiController < ActionController::API
    include DeviseTokenAuth::Concerns::SetUserByToken

    before_action :authenticate_api_v1_user!
  end
end
