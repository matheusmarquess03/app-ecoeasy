class Backoffice::TruckersController < BackofficeController
  before_action :set_trucker_default_data, only: [:create]

  def index
    @truckers = Trucker.all
  end

  def new
    @trucker = Trucker.new
  end

  def create
    if @trucker.save!
      flash[:success] = 'Caminhoneiro cadastrado com sucesso'
    else
      flash[:alert] = 'Falha para cadastrar o Caminhoneiro. Tente novamente mais tarde'
    end
    redirect_to backoffice_truckers_path
  end

  def edit
    @trucker = Trucker.find(params[:id])
  end

  def update
    @trucker = Trucker.find(params[:id])
    if @trucker.update!(trucker_params)
      flash[:success] = 'Caminhoneiro cadastrado com sucesso'
    else
      flash[:alert] = 'Falha para cadastrar o Caminhoneiro. Tente novamente mais tarde'
    end
    redirect_to backoffice_truckers_path
  end

  def destroy
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

  def set_trucker_default_data
    @trucker = Trucker.new(trucker_params)
    @trucker.provider = 'email'
  end
end
