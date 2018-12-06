class Backoffice::Evidences::SimpleEvidencesController < BackofficeController
  def index
    @evidences = Evidence.simple_evidence
  end

  def show
    @evidence = Evidence.find(params[:id])
  end

  private

  def evidences_params
    #code
  end
end
