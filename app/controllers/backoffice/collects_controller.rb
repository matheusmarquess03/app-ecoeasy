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

  # Propor data de atendimento: OK
  def update
    begin
      @collect.transaction do
        @collect.update(collect_date: update_params[:free_schedule])
        @collect.proposed_date!
        @collect.user << User.find(update_params[:trucker_id])
        current_trucker_schedule = @collect.trucker.schedule.where(work_day: update_params[:free_schedule]).first
        flash[:notice] = 'Agenda selecionada com sucesso'
        redirect_to backoffice_schedule_path(current_trucker_schedule)
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
    params.fetch(:collect, {}).permit(:collect_date, :user)
  end

  def set_free_schedules_to_options
    @free_schedules = Schedule.free_schedules
  end

  def set_collect
    @collect = Collect.find(params[:id])
  end
end
