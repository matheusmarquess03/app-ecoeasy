module Api::V1
  class ApiController <  ActionController::API
    include DeviseTokenAuth::Concerns::SetUserByToken

    # skip_before_action :verify_authenticity_token
    before_action :authenticate_user!

    # Métodos globais
  end
end
