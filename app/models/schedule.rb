class Schedule < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :collects

  # Validations
  validates :work_day, uniqueness: {
    scope: :user_id,
    message: "should there is one per user"
  }

  # Scopes
  scope :free_schedules, -> {
    joins(:user).
    where(full_schedule: false).
    order('users.name, work_day ASC')
  }

  # Methods
end
