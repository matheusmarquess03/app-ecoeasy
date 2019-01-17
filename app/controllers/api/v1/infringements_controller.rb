module Api::V1
  class InfringementsController < ApiController
    def index
      render json: { message: 'Você não tem acesso para fazer esta ação' }, status: :forbidden if current_api_v1_user.type != 'Client'
      @infringements = current_api_v1_user.evidences

    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
