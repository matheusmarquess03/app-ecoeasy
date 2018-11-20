class Landfill < ApplicationRecord
  # Associations
  has_many :collects
  has_one  :address, dependent: :destroy
  # accepts_nested_attributes_for :address
end
