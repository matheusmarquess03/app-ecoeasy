# frozen_string_literal: true

module Backoffice
  class RoutesController < BackofficeController
    before_action :set_route, only: %i[show edit update destroy]

    def index
      @routes = Route.all
    end

    def show; end

    def new
      @route = Route.new
      @route.address.build unless @route.address.present?
    end

    def create
      @route = Route.new(route_params)
      if @route.save
        flash[:success] = 'Rota criada com sucesso'
        redirect_to backoffice_routes_path
      else
        map_error = @route.errors.full_messages.find { |message| message.include?('mapa') }
        flash[:alert] = "Falha para cadastrar rota. #{map_error if map_error.present?}"
        render :new
      end
    end

    def edit; end

    def update
      @route.update!(route_params)
      flash[:success] = 'Rota atualizada com sucesso'
      redirect_to backoffice_routes_path
    rescue StandardError
      flash[:alert] = 'Falha para atualizar a rota. Tente novamente mais tarde'
      render :edit
    end

    def destroy
      @route.destroy!
      flash[:success] = 'Rota deletada com sucesso'
      redirect_to backoffice_routes_path
    rescue StandardError
      flash[:alert] = 'Falha para deletar rota. Tente novamente mais tarde'
      render :edit
    end

    private

    def route_params
      params.fetch(:route, {})
            .permit(
              :title,
              :description,
              address_attributes: address_attributes
            )
    end

    def address_attributes
      %i[id number street district city state country zip_code latitude
         longitude default _destroy]
    end

    def set_route
      @route = Route.find(params[:id])
    end
  end
end
