class ReverseGeocodingJob < ApplicationJob
  queue_as :default

  def perform(address_id)
    address = Address.find(address_id)
    address.geocode
    address.save!
  end
end
