class Schedule < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :work_day, uniqueness: {
    scope: :user_id,
    message: "should there is one per user"
  }

  # Scopes

  # Methods
end
