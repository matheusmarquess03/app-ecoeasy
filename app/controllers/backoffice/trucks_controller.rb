class Backoffice::TrucksController < BackofficeController
  before_action :set_truck, only: [:edit, :update, :destroy]
  def index
    @trucks = Truck.all
    if @trucks.blank?
      flash[:info] = 'Não há caminhões cadastrado até o momento'
      redirect_to new_backoffice_truck_path
    end
  end

  def new
    @truck = Truck.new
  end

  def create
    @truck = Truck.new(trucks_params)
    if @truck.save
      flash[:success] = 'Caminhão cadastrado com sucesso'
      redirect_to backoffice_trucks_path
    else
      flash[:alert] = 'Falha para cadastrar o caminhão. Tente novamente mais tarde'
      render :new
    end
  end

  def edit
  end

  def update
    if @truck.update(trucks_params)
      flash[:success] = 'Caminhão cadastrado com sucesso'
      redirect_to backoffice_trucks_path
    else
      flash[:alert] = 'Falha para atualizar o caminhão. Tente novamente mais tarde'
      render :edit
    end
  end

  def destroy
    if @truck.destroy
      flash[:success] = 'Caminhão deletado com sucesso'
      redirect_to backoffice_trucks_path
    else
      flash[:alert] = 'Falha para deletar o caminhão. Tente novamente mais tarde'
      render :edit
    end
  end

  private

  def set_truck
    @truck = Truck.find(params[:id])
  end

  def trucks_params
    params.fetch(:truck, {}).permit(:truck_type, :brand, :model, :manufacture_year, :color, :plate_number, :chassis_number, :renavam_number, :registration_number, :maximum_load, :m_3, :axles_number)
  end
end
