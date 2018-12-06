class Backoffice::Evidences::IncidentsController < BackofficeController
  def index
    @evidences = Evidence.incident
  end

  def show
    @evidence = Evidence.find(params[:id])
  end

  private

  def evidences_params
    #code
  end
end
