module Backoffice
  class RoutesController < BackofficeController
    before_action :set_route, only: [:show, :edit, :update, :destroy]

    def index
      @routes = Route.all
    end

    def show
    end

    def new
      @route = Route.new
      @route.address.build unless @route.address.present?
    end

    def create
      @route = Route.new(route_params)
      @route.save!
      flash[:success] = 'Rota criada com sucesso'
      redirect_to backoffice_routes_path
    rescue
      flash[:alert] = "Falha para cadastrar rota. Tente novamente mais tarde"
      render :new
    end

    def edit
    end

    def update
      @route.update!(route_params)
      flash[:success] = 'Rota atualizada com sucesso'
      redirect_to backoffice_routes_path
    rescue
      flash[:alert] = 'Falha para atualizar a rota. Tente novamente mais tarde'
      render :edit
    end

    def destroy
      @route.destroy!
      flash[:success] = 'Rota deletada com sucesso'
      redirect_to backoffice_routes_path
    rescue
      flash[:alert] = 'Falha para deletar rota. Tente novamente mais tarde'
      render :edit
    end

    def trucker_tracking
      @schedules_trackable = Schedule.trackable
    end

    private

    def route_params
      params.fetch(:route, {}).permit(:title, :description, address_attributes: [:id, :district, :city, :state, :country, :latitude, :longitude, :default, :_destroy])
    end

    def set_route
      @route = Route.find(params[:id])
    end
  end
end
