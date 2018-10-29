module Api::V1
  class CollectsController < ApiController
    before_action :set_collect, only: [:update]

    def create
      @collect = Collect.new
      @collect.user_id = current_api_v1_user.id
      @collect.type_collect = 'rubble_collect'
      @collect.address_id = collects_params[:address_id].to_i
      @collect.save!
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def update
      @collect.update!(status: collects_params[:status].to_i)
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def collects_params
      params.fetch(:collect, {}).permit(:status, :address_id)
    end

    def set_collect
      @collect = Collect.find(params[:id])
    end
  end
end
