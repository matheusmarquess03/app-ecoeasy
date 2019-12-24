# frozen_string_literal: true

class Route < ApplicationRecord
  # Callbacks
  before_validation :remove_last_address_blank

  # Associations
  has_many   :schedules_routes
  has_many   :schedules, through: :schedules_routes
  has_many   :address, dependent: :destroy

  accepts_nested_attributes_for :address,
                                reject_if: :all_blank,
                                allow_destroy: true

  # Validations
  validates_presence_of :address, allow_blank: false
  validate :address_cant_be_blank

  # Scopes
  scope :current_route, lambda { |trucker|
    joins(:schedule)
      .where(schedules: { work_day: Date.today, user_id: trucker.id })
  }

  # Methods

  private

  def remove_last_address_blank
    return unless address.last.latitude.blank? || address.last.longitude.blank?

    address.last.destroy
  end

  def address_cant_be_blank
    countries = address.map(&:country)

    if countries.all?(&:blank?)
      errors.add(:base, 'Você deve selecionar ao menos 1 ponto no mapa')
    end
  end
end
