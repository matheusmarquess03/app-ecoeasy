class Backoffice::EvidencesController < BackofficeController
  def index
    @evidences = Evidence.all
  end

  private

  def evidences_params
    #code
  end
end
