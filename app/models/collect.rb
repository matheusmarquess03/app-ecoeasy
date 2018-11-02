class Collect < ApplicationRecord
  # Enumerators
  enum status: [:requested, :proposed_date, :confirmed, :cancelled, :collected]
  enum type_collect: [:rubble_collect, :daily_garbage_collection, :road_cleaning]

  # Associations
  belongs_to :user
  belongs_to :schedule, optional: true
  belongs_to :address

  # Validates
  validates :address_id, presence: true

  # Scopes
  scope :scheduled, -> {
    where(status: [ Collect.statuses[:proposed_date], Collect.statuses[:confirmed] ])
  }

  # Methods
  def client
    self.user
  end
end
