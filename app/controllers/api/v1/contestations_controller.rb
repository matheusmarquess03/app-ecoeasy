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
      @infringement = Evidence.find(params[:infringement_id])
      InfringementMailer.with(infringement: @infringement).send_contestation_form.deliver

      render json: { message: 'Preencha o formulario enviado para seu e-mail, e reenvie-o para ecoeasy.contato@gmail.com' }, status: 200

    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def contestation_params
      params.fetch(:contestation, {}).permit(:infringement_id)
    end
  end
end
