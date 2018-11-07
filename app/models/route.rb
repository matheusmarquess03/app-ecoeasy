class Route < ApplicationRecord
  # Associations
  belongs_to :schedule
  has_many   :address

  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  # Validations

  # Scopes

  # Methods
end
