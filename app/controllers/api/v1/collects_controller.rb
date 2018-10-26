module Api::V1
  class CollectsController < ApiController
    before_action :set_collect, only: [:update]

    def update
      @collect.update!(collects_params[:status].to_i)
      render json: { message: 'status da coleta alterado com sucesso' }, status: 200
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def collects_params
      params.fetch(:collect, {}).permit(:status)
    end

    def set_collect
      @collect = Collect.find(params[:id])
    end
  end
end
