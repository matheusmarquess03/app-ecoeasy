class Backoffice::CollectsController < BackofficeController
  before_action :set_collect, only: [:edit, :update]
  before_action :set_free_schedules_to_options, only: [:edit, :index]

  def index
    @collects = Collect.rubble_collect
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    begin
      @collect.transaction do
        @collect.update(collect_params)
        @collect.proposed_date!
        schedule = Schedule.find(collect_params[:schedule_id])
        flash[:notice] = 'Agenda selecionada com sucesso'
        redirect_to backoffice_schedule_path(schedule)
      end
    rescue
      flash[:alert] = 'Falha para selecionar a agenda'
      redirect_to backoffice_collects_path
    end
  end 

  private

  def update_params
    free_schedule_params = collect_params.fetch(:user, {}).split(" ")
    { free_schedule: free_schedule_params[0], trucker_id: free_schedule_params[1] }
  end

  def collect_params
    params.fetch(:collect, {}).permit(:collect_date, :schedule_id)
  end

  def set_free_schedules_to_options
    @free_schedules = Schedule.free_schedules
  end

  def set_collect
    @collect = Collect.find(params[:id])
  end
end
