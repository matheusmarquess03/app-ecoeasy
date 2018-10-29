module Api::V1
  class EvidencesController < ApiController
    def create
      @evidence = Evidence.new(evidence_params)
      @evidence.user_id = current_api_v1_user.id
      @evidence.save!
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def evidence_params
      params.fetch(:evidence, {}).permit(:description)
    end
  end
end
