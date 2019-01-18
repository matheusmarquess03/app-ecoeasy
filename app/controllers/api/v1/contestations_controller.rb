module Api::V1
  class ContestationsController < ApiController
    def index
      @contestations = Contestation.all

    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def create
      binding.pry
      @contestation = current_api_v1_user.contestations.new
      @contestation.evidence_id   = params[:infringement_id]
      @contestation.justification = contestation_params[:justification]
      @contestation.save!

    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def contestation_params
      params.fetch(:contestation, {}).permit(:infringement_id, :justification)
    end
  end
end
