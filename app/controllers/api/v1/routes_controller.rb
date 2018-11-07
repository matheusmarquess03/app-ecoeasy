module Api::V1
  class RoutesController < ApiController
    before_action :set_day_route, only: [:show]

    def show
      unless @route.present?
        render json: { message: 'Não há rota programada para hoje para este caminhoneiro' }
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def set_day_route
      @route = Route.current_route(current_api_v1_user)
    end
  end
end
