# frozen_string_literal: true

class Backoffice::Evidences::SimpleEvidencesController < BackofficeController
  before_action :set_evidence, only: %i[show edit update]

  def index
    @evidences = Evidence.simple_evidence
                         .order(created_at: :desc)
                         .paginate(page: params[:page])
  end

  def show; end

  def edit; end

  def update
    @evidence.update!(evidence_params)
    flash[:notice] = 'Evidência atualizada com sucesso'
    redirect_to backoffice_evidences_simple_evidence_path(@evidence)
  rescue StandardError
    flash[:alert] = 'Falha ao atualizar a Evidência.'
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
