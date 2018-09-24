module Backoffice::ScheduleHelper
  def address_formatted(address)
    "#{address.street}, #{address.number} - #{address.city}, #{address.state} - #{address.country}"
  end
end
