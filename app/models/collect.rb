class Collect < ApplicationRecord
  # Enumerators
  enum status: [:requested, :proposed_date, :confirmed, :cancelled, :collected]
  enum type_collect: [:rubble_collect, :daily_garbage_collection, :road_cleaning]

  # Associations
  has_and_belongs_to_many :user


  # Validates

  # Scopes

  # Methods
  def trucker
    self.user.where(type: 'Trucker').first
  end

  def client
    self.user.where(type: 'Client').first
  end
end
