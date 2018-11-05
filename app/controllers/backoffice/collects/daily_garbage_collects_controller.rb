module Backoffice::Collects
  class DailyGarbageCollectsController < BackofficeController

    def index
      @collects = Collect.daily_garbage_collection
    end

    private

    def collect_params
      params.fetch(:collect, {}).permit(:collect_date, :schedule_id)
    end
  end
end
