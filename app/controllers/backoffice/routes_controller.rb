module Backoffice
  class RoutesController < BackofficeController
    before_action :set_users_schedule_options_for_select, only: [:new, :edit]

    def index
      @routes = Route.all
    end

    def new
      @route = Route.new
    end

    def create
      @route = Route.new(route_params)
      if @route.save!
        flash[:success] = 'Agenda cadastrado com sucesso'
        redirect_to backoffice_routes_path
      else
        flash[:alert] = 'Falha para cadastrar a agenda. Tente novamente mais tarde'
        redirect_to new_backoffice_route_path
      end
    end

    private

    def route_params
      params.fetch(:route, {}).permit(:schedule_id, address_attributes: [:id, :district, :city, :state, :country, :latitude, :longitude, :_destroy])
    end

    def set_users_schedule_options_for_select
      @schedules = Schedule.where('work_day > ?', Date.today)
    end
  end
end
