module Api::V1
  class InfringementsController < ApiController
    before_action :set_infringement, only: [:show, :send_bill_to_email]
    before_action :authorization_user

    def index
      @infringements = Evidence.where(citizen_cpf: current_api_v1_user.cpf)

    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def show
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def send_bill_to_email
      InfringementMailer.with(infringement: @infringement).send_bill_infringement.deliver

      render json: { message: 'Boleto enviado com sucesso' }, status: 200
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def infringements_params
      params.fetch(:evidence, {}).permit(:id)
    end

    def set_infringement
      @infringement = Evidence.find(params[:id])
    end

    def authorization_user
      render json: { message: 'Você não tem acesso para fazer esta ação' }, status: :forbidden if current_api_v1_user.type != 'Client'
    end
  end
end
