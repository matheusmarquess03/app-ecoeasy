class Evidence < ApplicationRecord
  # Callbacks
  before_validation :generate_protocol_number, on: :create

  # Enumerators
  enum evidence_type: %i[simple_evidence incident advertence mulct]
  enum status: %i[created attended]

  # Associations
  belongs_to :user
  belongs_to :address, optional: true

  has_many :comments
  has_one  :contestation

  accepts_nested_attributes_for :comments

  has_many_attached :images
  has_one_attached  :bill
  has_one_attached  :signature

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
    return unless images.attached?

    images_array = []
    images.map { |image| images_array << image.service_url }
    return images_array
  end

  def supervisor
    User.find(user_id)
  end

  def client
    User.find_by_cpf(citizen_cpf)
  end

  private

  def generate_protocol_number
    Evidence.last == nil ? id = 0 : id = Evidence.last.id
    self.protocol_number = "#{id + 1}#{DateTime.now.to_i}"
  end

  def cant_delegate_to_created_evidence
    return if new_record? || created? || !user_id_changed?

    errors.add(:user_id, 'Supervisor não pode ser alterado.')
  end
end
