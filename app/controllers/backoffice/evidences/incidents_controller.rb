class Backoffice::Evidences::IncidentsController < BackofficeController
  before_action :set_evidence, only: %i[show edit update]

  def index
    @evidences = Evidence.incident
                         .order(created_at: :desc)
                         .paginate(page: params[:page], per_page: 10)
  end

  def show; end

  def edit; end

  def update
    @evidence.update!(evidence_params)
    flash[:notice] = 'Ocorrência atualizada com sucesso'
    redirect_to backoffice_evidences_incident_path(@evidence)
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "#{e}"
    render :edit
  rescue StandardError
    flash[:alert] = 'Falha ao atualizar a Ocorrência.'
    render :edit
  end

  private

  def set_evidence
    @evidence = Evidence.find(params[:id])
  end

  def evidence_params
    params.fetch(:evidence, {}).permit(:user_id)
  end
end
