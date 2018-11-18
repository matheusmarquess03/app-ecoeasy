class Address < ApplicationRecord
  # Callbacks
  before_validation :prepare_user_addresses_before_update, on: :update

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
  private

  def prepare_user_addresses_before_update
    if self.default == true
      current_client_addresses = Address.where(user_id: self.user_id).where.not(id: self.id)
      current_client_addresses.map { |address| address.update_attribute('default', false)  }
    end
  end
end
