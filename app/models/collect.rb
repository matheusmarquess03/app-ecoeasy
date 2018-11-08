class Collect < ApplicationRecord
  # Enumerators
  enum status: [:requested, :proposed_date, :confirmed, :cancelled, :collected]
  enum type_collect: [:rubble_collect, :daily_garbage_collection, :road_cleaning]

  # Associations
  belongs_to :user
  belongs_to :schedule, optional: true
  belongs_to :address, optional: true

  # Validates
  validates :address_id, presence: true, if: :not_daily_garbage_collection?

  # Scopes
  scope :scheduled, -> {
    where(status: [ Collect.statuses[:proposed_date], Collect.statuses[:confirmed] ])
  }

  # Methods
  def client
    self.user
  end

  private

  def not_daily_garbage_collection?
    type_collect != 'daily_garbage_collection'
  end
end
