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

  def return_lat_lng_locations
    locations = []
    @collects.each do |collect|
      if collect.address.latitude.present? && collect.address.longitude.present?
        locations << [
          collect.address.latitude.to_f,
          collect.address.longitude.to_f,
          collect.status
        ]
      end
    end
    return locations
  end
end
