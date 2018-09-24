module Api::V1
  class ApiController < ActionController::API
    include DeviseTokenAuth::Concerns::SetUserByToken

    before_action :authenticate_user!
  end
end
