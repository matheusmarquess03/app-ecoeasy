module Backoffice::CollectHelper
  def route_selected(collect)
    route_in_params = params.fetch(:collect, {}).fetch(:schedules_routes, {})[:route_id]
    if route_in_params.present?
      return route_in_params
    else
      return collect&.schedule&.routes&.first&.id
    end
  end

  def collects_statuses_i18n
    Collect.statuses.to_a.map { |w| [ I18n.t("enums.collects.status.#{w[0]}"), w[1] ] }
  end

  def collect_params
    if params[:q].present?
      return { status_eq: params[:q][:status_eq], collect_date_gteq: params[:q][:collect_date_gteq] }
    else
      return ''
    end
  end
end
