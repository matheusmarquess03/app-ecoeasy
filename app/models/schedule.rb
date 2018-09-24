class Schedule < ApplicationRecord
  # Associations
  belongs_to :user

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

  def collects_scheduled_to_trucker
    self.user.collect.where(collect_date: self.work_day).where(status: ['proposed_date', 'confirmed']).count
  end
end
