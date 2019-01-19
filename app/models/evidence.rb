class Evidence < ApplicationRecord
  # Enumerators
  enum evidence_type: %i[simple_evidence incident advertence mulct]
  enum status: %i[created attended]

  # Associations
  belongs_to :user
  belongs_to :address, optional: true

  has_one :contestation

  has_many_attached :images
  has_one_attached  :bill

  validate :cant_delegate_to_created_evidence

  # Scopes
  scope :todays_evidences, ->(user) {
    where(user: user).
    where('created_at BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day)
  }

  scope :infringements, -> {
    where(evidence_type: [ Evidence.evidence_types[:advertence], Evidence.evidence_types[:mulct] ])
  }

  # Methods
  def get_all_images_url
    images.attached?
    images.map { |image| ActiveStorage::Blob.service.send(:path_for, image.key) }
  end

  def supervisor
    User.find(user_id)
  end

  def client
    User.find(client_id)
  end

  private

  def cant_delegate_to_created_evidence
    return if new_record? || created? || !user_id_changed?

    errors.add(:user_id, 'Supervisor não pode ser alterado.')
  end
end
