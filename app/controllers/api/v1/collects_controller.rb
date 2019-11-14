# frozen_string_literal: true

module Api::V1
  class CollectsController < ApiController
    before_action :set_collect, only: [:update]

    def index
      @collects = current_api_v1_user.collects
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

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

    def dump_collects
      @collects = Collect.collects_to_dump_by_trucker(current_api_v1_user.id)
      unless @collects.present?
        render json: { message: 'Não há coletas pendentes para despejo relacionadas a este motorista' }
      end

      Collect.transaction do
        @collects.map do |collect|
          collect.update!(collects_params)
          collect.dumped!
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.message }, status: 422
    rescue StandardError => e
      render json: { message: e.message }, status: 500
    end

    private

    def collects_params
      params.fetch(:collect, {}).permit(
        :status, :address_id, :landfill_id, :weight
      )
    end

    def set_collect
      @collect = Collect.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { message: 'Coleta não encontrada' }, status: 404
    end
  end
end
