class Schedule < ApplicationRecord
  # Associations
  belongs_to :user
  has_many   :collects
  has_many   :schedules_routes
  has_many   :routes, through: :schedules_routes

  # Validations
  validates :work_day, uniqueness: {
    scope: :user_id,
    message: "should there is one per user"
  }

  # Scopes
  scope :free_schedules, -> {
    joins(:user).
    where(full_schedule: false).
    where('work_day >= (?)', Date.today).
    order('users.name, work_day ASC')
  }

  scope :trackable, -> {
    joins(:routes).
    where(work_day: Date.today).
    distinct
  }

  # Methods
  def self.free_schedules_to_daily_collects
    schedules = []
    self.free_schedules.map do |s|
      schedules << s if s.collects.count == 0
    end
    return schedules
  end

  def trucker_schedule_label
    "#{self.user.name} - #{I18n.l self.work_day, :format => :long, :locale => 'pt-BR'}"
  end

  def firebase_reference_access
    "#{self.work_day.strftime('%Y-%m-%d')}/#{self.user_id}"
  end
end
