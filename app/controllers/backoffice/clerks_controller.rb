class Backoffice::ClerksController < BackofficeController
  before_action :set_clerk_default_data, only: [:create]
  before_action :set_clerk, only: [:edit, :update, :destroy]

  def index
    @clerks = Clerk.all.order(name: :asc)
  end

  def new
    @clerk = Clerk.new
  end

  def create
    if @clerk.save
      flash[:success] = 'Atendente cadastrado com sucesso'
      redirect_to backoffice_clerks_path
    else
      flash[:alert] = 'Falha para cadastrar o Atendente'
      render :new
    end
  end

  def edit; end

  def update
    if @clerk.update!(clerk_params)
      flash[:success] = 'Atendente cadastrado com sucesso'
      redirect_to backoffice_clerks_path
    else
      flash[:alert] = 'Falha para cadastrar o Atendente'
      render :edit
    end
  end

  def destroy
    if @clerk.destroy
      flash[:success] = 'Atendente deletado com sucesso'
    else
      flash[:alert] = 'Falha para deletar Atendente'
    end
    redirect_to backoffice_clerks_path
  end

  private

  def clerk_params
    return params.fetch(:clerk, {}).permit(:name, :phone_number, :cpf, :email) if password_blank?
    params.fetch(:clerk, {}).permit(:name, :email, :cpf, :phone_number, :password, :password_confirmation)
  end

  def password_blank?
    params[:clerk][:password].blank? &&
      params[:clerk][:password_confirmation].blank?
  end

  def set_clerk
    @clerk = Clerk.find(params[:id])
  end

  def set_clerk_default_data
    @clerk = Clerk.new(clerk_params)
    # @clerk.provider = 'email'
  end
end
