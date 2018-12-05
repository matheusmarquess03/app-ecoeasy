class Backoffice::Evidences::IncidentsController < BackofficeController
  def index
    @evidences = Evidence.incident
  end

  private

  def evidences_params
    #code
  end
end
