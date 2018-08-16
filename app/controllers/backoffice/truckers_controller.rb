class Backoffice::TruckersController < ApplicationController
  def index
    @truckers = Trucker.all
  end

  def new
    @trucker = Trucker.new
  end

  def create
    @trucker = Trucker.new(trucker_params)
    if @trucker.save
      flash[:success] = 'Caminhoneiro cadastrado com sucesso'
    else
      flash[:success] = 'Falha para cadastrar o Caminhoneiro. Tente novamente mais tarde'
    end
    redirect_to backoffice_truckers_path
  end

  def edit
    @trucker = Trucker.find(params[:id])
  end

  def update
    @trucker = Trucker.find(params[:id])
    if @trucker.update(trucker_params)
      flash[:success] = 'Caminhoneiro cadastrado com sucesso'
    else
      flash[:success] = 'Falha para cadastrar o Caminhoneiro. Tente novamente mais tarde'
    end
    redirect_to backoffice_truckers_path
  end

  def destroy
  end

  private

  def trucker_params
    params.fetch(:trucker, {}).permit(:name, :email)
  end
end
