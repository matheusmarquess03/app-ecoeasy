class Route < ApplicationRecord
  # Associations
  has_many   :schedule, through: :schedules_route
  has_many   :address, dependent: :destroy

  accepts_nested_attributes_for :address, reject_if: :all_blank, allow_destroy: true

  # Validations

  # Scopes
  scope :current_route, ->(trucker) {
    joins(:schedule).
    where(schedules: { user_id: trucker.id }).first
    # where(schedules: { work_day: Date.today, user_id: trucker.id })
  }

  # Methods
end
