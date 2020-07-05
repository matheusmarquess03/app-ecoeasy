class Backoffice::DashboardController < BackofficeController
  def index
    @mulcts = Evidence.mulct
    @incidents = Evidence.incident
    @rubble_collects = Collect.rubble_collect.collected
    @daily_collect = Collect.daily_garbage_collection.collected
	
	@monthly_collect_weight = Collect.monthly_collect
	@monthly_collect_distance = FirebaseDatum.monthly_collect
  end
end
