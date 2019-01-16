module Api::V1
  class EvidencesController < ApiController
    before_action :authorization_user

    def index
      @evidences = Evidence.todays_evidences(current_api_v1_user)
    end

    def create
      @evidence = Evidence.new(evidence_params)
      @evidence.user_id = current_api_v1_user.id
      @evidence.evidence_type = params[:evidence_type].to_i

      attach_images
      @evidence.save!
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def update
      #code
    end

    private

    def authorization_user
      render json: { message: 'Você não tem acesso para fazer esta ação' }, status: :forbidden if current_api_v1_user.type != 'Supervisor'
    end

    def evidence_params
      params.fetch(:evidence, {}).permit(:description, :full_address, :citizen_cpf)
    end

    def attach_images
      Array(params[:images]).each do |image|
        Images::Attach.new(@evidence.images, image).run
      end
    end
  end
end
