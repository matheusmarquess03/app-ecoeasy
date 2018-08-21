class Backoffice::TruckersController < BackofficeController
  before_action :set_trucker_default_data, only: [:create]

  def index
    @truckers = User.trucker
  end

  def new
    @trucker = User.new
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
    @trucker = User.find(params[:id])
  end

  def update
    @trucker = User.find(params[:id])
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
    return params.fetch(:user, {}).permit(:name, :email) if password_blank?
    params.fetch(:user, {}).permit(:name, :email, :password, :password_confirmation)
  end

  def password_blank?
    params[:user][:password].blank? &&
    params[:user][:password_confirmation].blank?
  end

  def set_trucker_default_data
    @trucker = User.new(trucker_params)
    @trucker.access_profile = 'trucker'
    @trucker.provider = 'email'
  end
end
