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

  # Propor data de atendimento
  def update
    begin
      @collect.transaction do
        @collect.update(collect_date: update_params[:free_schedule], status: proposed_date)
        @collect.user << User.find(update_params[:trucker_id])
        flash[:success] = 'Sugestão de data enviada para o cidadão'
        redirect_to backoffice_collects_path
      end
    rescue
      flash[:alert] = 'Falha para selecionar sugestão de data para a coleta'
      redirect_to backoffice_collects_path
    end
    flash[:alert] = 'Falha para selecionar sugestão de data para a coleta'
    render :index
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
    @free_schedules = Schedule.joins(:user).where(full_schedule: false).order('users.name, work_day ASC')
  end

  def set_collect
    @collect = Collect.find(params[:id])
  end
end
