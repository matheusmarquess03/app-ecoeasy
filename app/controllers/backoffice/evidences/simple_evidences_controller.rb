class Backoffice::Evidences::SimpleEvidencesController < BackofficeController
  def index
    @evidences = Evidence.simple_evidence
  end

  private

  def evidences_params
    #code
  end
end
