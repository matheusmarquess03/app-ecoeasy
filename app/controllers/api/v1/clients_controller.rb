module Api::V1
  class ClientsController < ApiController
    skip_before_action :authenticate_api_v1_user!, only: [:already_registered]

    def already_registered
      @client = Client.where('cpf = ? OR email = ?', client_params[:login], client_params[:login])
      render json: { registered: @client.present? }, status: 200
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def user_session_active
      render json: { session_active: true }, status: 200
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def search
      render json: { message: 'Você não tem acesso para fazer esta ação' }, status: :forbidden if current_api_v1_user.type != 'Supervisor'
      @client = Client.find_by_cpf(client_params[:cpf])
      render json: { message: 'Cidadão não cadastrado até o momento' }, status: :not_found  unless @client.present?
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def client_params
      params.permit(:login, :cpf)
    end
  end
end
