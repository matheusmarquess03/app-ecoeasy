class Backoffice::LandfillsController < BackofficeController
  before_action :set_landfill, only: [:edit, :update, :destroy]

  def index
    @landfills = Landfill.all
  end

  def new
    @landfill = Landfill.new
  end

  def create
    @landfill = Landfill.new(landfills_params)
    @landfill.transaction do
      @landfill.save!
      @address = Address.new(address_params)
      @address.landfill_id = @landfill.id
      @address.save!
    end
    flash[:success] = 'Aterro cadastrado com sucesso'
    redirect_to backoffice_landfills_path
  rescue
    flash[:alert] = 'Falha para cadastrar o aterro. Tente novamente mais tarde'
    render :new
  end

  def edit
  end

  def update
    @landfill.transaction do
      @landfill.update!(landfills_params)
      @landfill.address.update!(address_params)
    end
    flash[:success] = 'Aterro cadastrado com sucesso'
    redirect_to backoffice_landfills_path
  rescue
    flash[:alert] = 'Falha para atualizar o aterro. Tente novamente mais tarde'
    render :edit
  end

  def destroy
    if @landfill.destroy
      flash[:success] = 'Aterro deletado com sucesso'
      redirect_to backoffice_landfills_path
    else
      flash[:alert] = 'Falha para deletar o aterro. Tente novamente mais tarde'
      render :edit
    end
  end

  private

  def set_landfill
    @landfill = Landfill.find(params[:id])
  end

  def landfills_params
    params.fetch(:landfill, {}).permit(:name)
  end

  def address_params
    params.fetch(:landfill, {}).fetch(:address, {}).permit(:id, :street, :number, :complement, :district, :city, :state, :country)
  end
end
