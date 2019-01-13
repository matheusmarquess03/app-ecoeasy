class Address < ApplicationRecord
  geocoded_by :full_address
  after_validation :geocode, if: :address_changed?

  # Callbacks
  before_save    :change_default_address
  before_destroy :set_default_address

  # Associations
  belongs_to :user, optional: true
  belongs_to :route, optional: true
  belongs_to :landfill, optional: true

  has_many :collects
  has_many :evidences

  # Validations
  # validates :default, uniqueness: {
  #   scope: :user_id,
  #   message: "address should there is one per user"
  # }

  # Scopes

  # Methods

  def full_address
    [ street, number, district, city, state, country ].compact.join(', ')
  end

  def already_used?
    collects.present? || evidences.present? || landfill.present? || route.present?
  end

  private

  def address_changed?
    street_changed? || number_changed? || district_changed? || city_changed? || state_changed? || country_changed?
  end
  
  def set_default_address
    if self.default == true
      new_address_default = Address.where(user_id: self.user_id).where.not(id: self.id).first
      new_address_default.update(default: true) if new_address_default.present?
    end
  end

  def change_default_address
    if self.default == true && self.user_id.blank?
      client_id = Address.find(id).user_id
      new_address_default = Address.where(user_id: client_id).where.not(id: self.id).first
      new_address_default.update(default: true) if new_address_default.present?
    elsif self.default == true
      current_client_addresses = Address.where(user_id: self.user_id).where.not(id: self.id)
      current_client_addresses.map { |address| address.update_attribute('default', false)  }
    end
  end
end
