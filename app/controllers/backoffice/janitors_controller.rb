class Backoffice::JanitorsController < BackofficeController
  before_action :set_janitor_default_data, only: [:create]
  before_action :set_janitor, only: [:edit, :update, :destroy]

  def index
    @janitors = Janitor.all.order(name: :asc)
  end

  def new
    @janitor = Janitor.new
  end

  def create
    if @janitor.save
      flash[:success] = 'Zelador cadastrado com sucesso'
      redirect_to backoffice_janitors_path
    else
      flash[:alert] = 'Falha para cadastrar o Zelador'
      render :new
    end
  end

  def edit; end

  def update
    if @janitor.update!(janitor_params)
      flash[:success] = 'Zelador cadastrado com sucesso'
      redirect_to backoffice_janitors_path
    else
      flash[:alert] = 'Falha para cadastrar o Zelador'
      render :edit
    end
  end

  def destroy
    if @janitor.destroy
      flash[:success] = 'Zelador deletado com sucesso'
    else
      flash[:alert] = 'Falha para deletar Zelador'
    end
    redirect_to backoffice_janitors_path
  end

  private

  def janitor_params
    return params.fetch(:janitor, {}).permit(:name, :phone_number, :cpf, :email) if password_blank?
    params.fetch(:janitor, {}).permit(:name, :email, :cpf, :phone_number, :password, :password_confirmation)
  end

  def password_blank?
    params[:janitor][:password].blank? &&
      params[:janitor][:password_confirmation].blank?
  end

  def set_janitor
    @janitor = Janitor.find(params[:id])
  end

  def set_janitor_default_data
    @janitor = Janitor.new(janitor_params)
    @janitor.provider = 'email'
  end
end
