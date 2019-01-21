module Backoffice::DashboardHelper
  def get_coordenation_all_services
    locations = []

    @rubble_collects.each do |collect|
      if collect.address.latitude.present? && collect.address.longitude.present?
        locations << [
          collect.address.latitude.to_f,
          collect.address.longitude.to_f,
          collect.status,
          'rubble_collects'
        ]
      end
    end

    @daily_collect.each do |collect|
      if collect.address.latitude.present? && collect.address.longitude.present?
        locations << [
          collect.address.latitude.to_f,
          collect.address.longitude.to_f,
          collect.status,
          'daily_collect'
        ]
      end
    end

    @mulcts.each do |infringement|
      if infringement.latitude.present? && infringement.longitude.present?
        locations << [
          infringement.latitude.to_f,
          infringement.longitude.to_f,
          'infringement',
          'mulcts'
        ]
      end
    end

    @incidents.each do |infringement|
      if infringement.latitude.present? && infringement.longitude.present?
        locations << [
          infringement.latitude.to_f,
          infringement.longitude.to_f,
          'infringement',
          'incidents'
        ]
      end
    end

    return locations
  end
end
