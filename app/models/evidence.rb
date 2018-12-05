class Evidence < ApplicationRecord
  # Enumerators
  enum evidence_type: [:simple_evidence, :incident]

  # Associations
  belongs_to :user
  belongs_to :address, optional: true

  has_many_attached :images

  # Methods
  def supervisor
    self.user
  end
end
