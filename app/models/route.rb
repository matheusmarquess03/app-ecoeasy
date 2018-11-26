class Route < ApplicationRecord
  # Callbacks
  before_save :remove_last_address_blank

  # Associations
  has_many   :schedules_routes
  has_many   :schedules, through: :schedules_routes
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

  private

  def remove_last_address_blank
    if self.address.last.latitude.blank? || self.address.last.longitude.blank?
      self.address.last.destroy
    end
  end
end
