class Backoffice::InfringementsController < BackofficeController
  def index
    @infringements = Evidence.infringements
  end

  def show
    @infringement = Evidence.find(params[:id])
  end
end
