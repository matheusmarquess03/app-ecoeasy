module Api::V1
  class AddressController < ApiController
    before_action :set_address, only: [:update, :destroy]

    def index
      @addresses = Address.where(user_id: current_api_v1_user.id)
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def create
      @address = Address.new(address_params)
      @address.user_id = current_api_v1_user.id
      @address.save!
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def update
      @address.update!(address_params)
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    def destroy
      if @address.already_used?
        @address.update(user_id: nil)
      else
        @address.destroy
      end
      render json: { message: 'Endereço apagado com sucesso' }, status: 200
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def address_params
      params.fetch(:address, {}).permit(:street, :number, :complement, :district, :city, :state, :country, :zip_code, :latitude, :longitude, :default)
    end

    def set_address
      @address = Address.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { message: 'Endereço não encontrado' }, status: 404
    end
  end
end
