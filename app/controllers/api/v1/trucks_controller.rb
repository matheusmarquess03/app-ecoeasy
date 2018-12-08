module Api::V1
  class TrucksController < ApiController
    def index
      @trucks = Truck.all
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
