class Evidence < ApplicationRecord
  # Enumerators
  enum evidence_type: [:simple_evidence, :incident, :advertence, :mulct]

  # Associations
  belongs_to :user
  belongs_to :address, optional: true

  has_one :contestation

  has_many_attached :images
  has_one_attached  :bill
  has_one_attached  :signature

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
    return unless images.attached?
    images.map { |image| ActiveStorage::Blob.service.send(:path_for, image.key) }
  end

  def supervisor
    User.find(user_id)
  end

  def client
    User.find_by_cpf(citizen_cpf)
  end
end
