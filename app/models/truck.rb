class Truck < ApplicationRecord
  # Enums
  enum truck_type: [:open_bucket, :open_bady, :articulated_dump]

  # Associations
  has_many :schedule
end
