class Backoffice::TrucksController < BackofficeController
  def index
    @trucks = Truck.all
  end

  def new
    @truck = Truck.new
  end

  def create
    @truck = Truck.new(trucks_params)
    binding.pry
    if @truck.save
      flash[:success] = 'Caminhão cadastrado com sucesso'
      redirect_to backoffice_trucks_path
    else
      flash[:alert] = 'Falha para cadastrar o caminhão. Tente novamente mais tarde'
      render :new
    end
  end

  private

  def trucks_params
    params.fetch(:truck, {}).permit(:brand, :model, :manufacture_year, :color, :plate_number, :chassis_number, :renavam_number, :registration_number, :maximum_load, :m_3, :axles_number)
  end
end
