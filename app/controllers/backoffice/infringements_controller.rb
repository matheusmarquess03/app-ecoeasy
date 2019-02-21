class Backoffice::InfringementsController < BackofficeController
  before_action :set_infringement, only: %i[show update]

  def index
    @infringements = Evidence.infringements

    if params[:latitude].present? && params[:longitude].present?
      @infringements.order_by_distance(params[:latitude].to_f, params[:longitude].to_f)
    end
  end

  def show; end

  def update
    if @infringement.update(infringement_params)
      flash[:success] = 'Infração atualizada com sucesso'
      redirect_to backoffice_infringement_path(@infringement)
    else
      flash[:alert] = 'Falha ao atualizar a infração.'
      redirect_back fallback_location: backoffice_infringements_path
    end
  end

  private

  def set_infringement
    @infringement = Evidence.find(params[:id])
  end

  def infringement_params
    params.fetch(:infringement, {}).permit(:id, :status)
  end
end
