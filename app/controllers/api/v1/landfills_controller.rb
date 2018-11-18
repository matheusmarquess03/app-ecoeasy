module Api::V1
  class LandfillsController < ApiController
    def index
      @landfills = Landfill.all
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end
  end
end
