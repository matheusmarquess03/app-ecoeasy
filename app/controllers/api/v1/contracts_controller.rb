module Api::V1
  class ContractsController < ApiController
    before_action :set_contract, only: %i[update destroy]

    def index
      @contracts = Contract.all
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def show
      @contract = Contract.find(params[:id])
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def create
      @contract = Contract.new(contract_params)
      @contract.save!
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def update
      @contract.update!(contract_params)
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def destroy
      @contract.destroy!
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def contract_params
      params.fetch(:contract, {}).permit(:name, :observation, attachments: [])
    end

    def set_contract
      @contract = Contract.find(params[:id])
    end
  end
end
