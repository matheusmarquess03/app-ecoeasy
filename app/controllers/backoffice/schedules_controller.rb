class Backoffice::SchedulesController < BackofficeController
  before_action :set_users_collections_for_select, only: [:new, :edit]
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  def index
    @schedules = Schedule.all.order(:user_id, :work_day)
  end

  def show
    @collects = @schedule.user.collect.confirmed.where(collect_date: @schedule.work_day)
  end

  def new
    @schedule = Schedule.new
  end

  def create
    @schedule = Schedule.new(schedule_params)
    if @schedule.save
      flash[:success] = 'Agenda cadastrado com sucesso'
      redirect_to backoffice_schedules_path
    else
      flash[:alert] = 'Falha para cadastrar a agenda. Tente novamente mais tarde'
      redirect_to new_backoffice_schedule_path
    end
  end

  def edit
  end

  def update
    if @schedule.update(schedule_params)
      flash[:success] = 'Agenda alterada com sucesso'
    else
      flash[:alert] = 'Falha para alterar agenda. Tente novamente mais tarde'
    end
    redirect_to backoffice_schedules_path
  end

  def destroy
    if @schedule.destroy
      flash[:success] = 'Agenda deletada com sucesso'
      redirect_to backoffice_schedules_path
    else
      flash[:alert] = 'Falha para deletar agenda. Tente novamente mais tarde'
      render :edit
    end
  end

  private

  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  def schedule_params
    params.fetch(:schedule, {}).permit(:user_id, :work_day, :full_schedule)
  end

  def set_users_collections_for_select
    @users = Trucker.all
  end

end
