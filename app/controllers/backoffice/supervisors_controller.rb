class Backoffice::SupervisorsController < BackofficeController
  before_action :set_supervisor_default_data, only: [:create]
  before_action :set_supervisor, only: [:edit, :update, :destroy]

  def index
    @supervisors = Supervisor.all.order(name: :asc)
  end

  def new
    @supervisor = Supervisor.new
  end

  def create
    if @supervisor.save
      flash[:success] = 'Supervisor cadastrado com sucesso'
      redirect_to backoffice_supervisors_path
    else
      flash[:alert] = 'Falha para cadastrar o Supervisor'
      render :new
    end
  end

  def edit; end

  def update
    if @supervisor.update!(supervisor_params)
      flash[:success] = 'Supervisor cadastrado com sucesso'
      redirect_to backoffice_supervisors_path
    else
      flash[:alert] = 'Falha para cadastrar o Supervisor'
      render :edit
    end
  end

  def destroy
    if @supervisor.destroy
      flash[:success] = 'Supervisor deletado com sucesso'
    else
      flash[:alert] = 'Falha para deletar Supervisor'
    end
    redirect_to backoffice_supervisors_path
  end

  def tracking
    @supervisors = Supervisor.all
  end

  private

  def supervisor_params
    return params.fetch(:supervisor, {}).permit(:name, :phone_number, :cpf, :email) if password_blank?
    params.fetch(:supervisor, {}).permit(:name, :email, :cpf, :phone_number, :password, :password_confirmation)
  end

  def password_blank?
    params[:supervisor][:password].blank? &&
      params[:supervisor][:password_confirmation].blank?
  end

  def set_supervisor
    @supervisor = Supervisor.find(params[:id])
  end

  def set_supervisor_default_data
    @supervisor = Supervisor.new(supervisor_params)
    @supervisor.provider = 'email'
  end
end
