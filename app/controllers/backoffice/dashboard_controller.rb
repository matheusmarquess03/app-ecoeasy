class Backoffice::DashboardController < BackofficeController
  def index
    @mulcts = Evidence.mulct
    @incidents = Evidence.incident
    @rubble_collects = Collect.rubble_collect.collected
    @daily_collect = Collect.daily_garbage_collection.collected
  end
end
