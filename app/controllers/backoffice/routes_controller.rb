module Backoffice
  class RoutesController < BackofficeController
    before_action :set_users_schedule_options_for_select, only: [:new, :index, :edit]
    before_action :set_route, only: [:show, :edit, :update, :destroy]

    def index
      @routes = Route.all
    end

    def show
    end

    def new
      @route = Route.new
    end

    def create
      @route = Route.new(route_params)
      if @route.save!
        flash[:success] = 'Rota definanda com sucesso'
        redirect_to backoffice_routes_path
      else
        flash[:alert] = 'Falha para definir a rota. Tente novamente mais tarde'
        redirect_to new_backoffice_route_path
      end
    end

    def edit
    end

    def update
      if @route.save
        flash[:success] = 'Rota atualizada com sucesso'
        redirect_to backoffice_routes_path
      else
        flash[:alert] = 'Falha para atualizar a rota. Tente novamente mais tarde'
        redirect_to new_backoffice_route_path
      end
    end

    def destroy
      @route = Route.find(params[:id])
      if @route.destroy
        flash[:success] = 'Agenda deletada com sucesso'
        redirect_to backoffice_schedules_path
      else
        flash[:alert] = 'Falha para deletar agenda. Tente novamente mais tarde'
        render :edit
      end
    end

    private

    def route_params
      params.fetch(:route, {}).permit(:schedule_id, address_attributes: [:id, :district, :city, :state, :country, :latitude, :longitude, :_destroy])
    end

    def set_users_schedule_options_for_select
      @schedules = Schedule.where('work_day > ?', Date.today)
    end

    def set_route
      @route = Route.find(params[:id])
    end
  end
end
