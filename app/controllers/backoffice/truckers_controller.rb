class Backoffice::TruckersController < BackofficeController
  before_action :set_trucker_default_data, only: [:create]
  before_action :set_trucker, only: [:edit, :update, :destroy]

  def index
    @truckers = Trucker.all.order(name: :asc)
  end

  def new
    @trucker = Trucker.new
  end

  def create
    if @trucker.save
      flash[:success] = 'Caminhoneiro cadastrado com sucesso'
      redirect_to backoffice_truckers_path
    else
      flash[:alert] = 'Falha para cadastrar o Caminhoneiro'
      render :new
    end
  end

  def edit
  end

  def update
    if @trucker.update!(trucker_params)
      flash[:success] = 'Caminhoneiro cadastrado com sucesso'
      redirect_to backoffice_truckers_path
    else
      flash[:alert] = 'Falha para cadastrar o Caminhoneiro'
      render :edit
    end
  end

  def destroy
    if @trucker.destroy
      flash[:success] = 'Caminhoneiro deletado com sucesso'
    else
      flash[:alert] = 'Falha para deletar caminhoneiro'
    end
    redirect_to backoffice_truckers_path
  end

  private

  def trucker_params
    return params.fetch(:trucker, {}).permit(:name, :email) if password_blank?
    params.fetch(:trucker, {}).permit(:name, :email, :password, :password_confirmation)
  end

  def password_blank?
    params[:trucker][:password].blank? &&
    params[:trucker][:password_confirmation].blank?
  end

  def set_trucker
    @trucker = Trucker.find(params[:id])
  end

  def set_trucker_default_data
    @trucker = Trucker.new(trucker_params)
    @trucker.provider = 'email'
  end
end
