class Address < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :collects

  # Validates

  # Scopes

  # Methods
end
