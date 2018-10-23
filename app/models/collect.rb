class Collect < ApplicationRecord
  # Enumerators
  enum status: [:requested, :proposed_date, :confirmed, :cancelled, :collected]
  enum type_collect: [:rubble_collect, :daily_garbage_collection, :road_cleaning]

  # Associations
  belongs_to :user
  belongs_to :schedule, optional: true


  # Validates

  # Scopes

  # Methods
  def client
    self.user
  end
end
