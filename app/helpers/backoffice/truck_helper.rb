module Backoffice::TruckHelper
  def truck_types_i18n
    truck_types = {}
    Truck.truck_types.keys.each do |key|
      truck_types.merge! I18n.t("enums.trucks.truck_type.#{key}") => key
    end
    return truck_types
  end
end
