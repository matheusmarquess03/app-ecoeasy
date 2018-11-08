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
      begin
        schedule = Schedule.find(route_params[:schedule_id])
        @route = Route.new(route_params)
        @route.transaction do
          @route.save!
          Collect.create!(
            status: 'confirmed',
            type_collect: 'daily_garbage_collection',
            schedule_id: schedule.id,
            user_id: schedule.user.id,
            collect_date: schedule.work_day
          )
          schedule.update!(full_schedule: true)
        end
        flash[:success] = 'Rota definanda com sucesso'
        redirect_to backoffice_routes_path
      rescue StandardError => e
        flash[:alert] = "Falha para definir a rota. Tente novamente mais tarde - #{e}"
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
      begin
        @route = Route.find(params[:id])
        schedule = @route.schedule
        @route.transaction do
          schedule.collects.daily_garbage_collection.first.destroy
          schedule.update!(full_schedule: false)
          @route.destroy
        end
        flash[:success] = 'Rota deletada com sucesso'
        redirect_to backoffice_routes_path
      rescue
        flash[:alert] = 'Falha para deletar rota. Tente novamente mais tarde'
        render :edit
      end
    end

    def trucker_tracking
      @schedules_trackable = Schedule.trackable
    end

    private

    def route_params
      params.fetch(:route, {}).permit(:schedule_id, address_attributes: [:id, :district, :city, :state, :country, :latitude, :longitude, :default, :_destroy])
    end

    def set_users_schedule_options_for_select
      @schedules = Schedule.where('work_day >= ?', Date.today)
    end

    def set_route
      @route = Route.find(params[:id])
    end
  end
end
