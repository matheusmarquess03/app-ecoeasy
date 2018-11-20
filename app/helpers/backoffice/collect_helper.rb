module Backoffice::CollectHelper
  def route_selected(collect)
    route_in_params = params.fetch(:collect, {}).fetch(:schedules_routes, {})[:route_id]
    if route_in_params.present?
      return route_in_params
    else
      return collect&.schedule&.routes&.first&.id
    end
  end
end
