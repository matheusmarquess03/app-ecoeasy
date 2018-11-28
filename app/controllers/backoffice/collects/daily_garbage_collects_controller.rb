module Backoffice::Collects
  class DailyGarbageCollectsController < BackofficeController
    before_action :set_collect, only: [:edit, :update, :destroy]
    before_action :set_free_schedules_to_options, :set_routes_to_options, only: [:new, :create, :edit, :update, :index]

    def index
      @collects = Collect.daily_garbage_collection
      if @collects.blank?
        flash[:info] = 'Não há coletas cadastrado até o momento.'
        redirect_to new_backoffice_collects_daily_garbage_collect_path
      end
    end

    def new
      @collect = Collect.new
    end

    def create
      @collect = Collect.new(collect_params)
      schedule = Schedule.find(collect_params[:schedule_id])
      route    = Route.find(routes_params[:route_id])
      @collect.transaction do
        @collect.type_collect = 'daily_garbage_collection'
        @collect.collect_date = @collect.schedule.work_day
        @collect.confirmed!
        schedule.routes << route
        schedule.update!(full_schedule: true)
      end
      flash[:success] = 'Agendamento realizado com sucesso'
      redirect_to backoffice_collects_daily_garbage_collects_path
    rescue
      flash[:alert] = "Falha para realizar o agendamento. Tente novamente mais tarde"
      render :new
    end

    def edit
      @free_schedules << Schedule.find(@collect.schedule_id)
    end

    def update
      schedule = Schedule.find(collect_params[:schedule_id])
      route    = Route.find(routes_params[:route_id])
      @collect.transaction do
        @collect.schedule.update!(full_schedule: false)
        @collect.schedule.routes.delete(@collect.schedule.routes.first)
        @collect.update!(collect_params)
        @collect.collect_date = @collect.schedule.work_day
        @collect.save!
        schedule.reload
        schedule.routes << route
        schedule.update!(full_schedule: true)
      end
      flash[:success] = 'Agendamento realizado com sucesso'
      redirect_to backoffice_collects_daily_garbage_collects_path
    rescue
      flash[:alert] = "Falha para atualizar o agendamento. Tente novamente mais tarde"
      render :edit
    end

    def destroy
      @collect.transaction do
        @collect.schedule.update!(full_schedule: false)
        @collect.schedule.routes.delete(@collect.schedule.routes.first)
        @collect.destroy
      end
      flash[:success] = 'Agendamento deletado com sucesso'
      redirect_to backoffice_collects_daily_garbage_collects_path
    rescue
      flash[:alert] = "Falha para atualizar o agendamento. Tente novamente mais tarde"
      redirect_to backoffice_collects_daily_garbage_collects_path
    end

    def trucker_tracking
      @schedules_trackable = Schedule.trackable(Collect.type_collects[:daily_garbage_collection])
    end

    private

    def routes_params
      params.fetch(:collect, {}).fetch(:schedules_routes, {}).permit(:route_id)
    end

    def collect_params
      params.fetch(:collect, {}).permit(:schedule_id)
    end

    def set_routes_to_options
      @routes = Route.all
    end

    def set_free_schedules_to_options
      @free_schedules = Schedule.free_schedules_to_daily_collects
    end

    def set_collect
      @collect = Collect.find(params[:id])
    end
  end
end
