module Api::V1
  class ClientsController < ApiController
    skip_before_action :authenticate_api_v1_user!

    def already_registered?
      @client = Client.find_by_email(client_params[:email])
      render json: { registered: @client.present? }, status: 200
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def client_params
      params.permit(:email)
    end
  end
end
