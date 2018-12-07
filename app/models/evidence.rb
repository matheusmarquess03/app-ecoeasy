class Evidence < ApplicationRecord
  # Enumerators
  enum evidence_type: [:simple_evidence, :incident]

  # Associations
  belongs_to :user
  belongs_to :address, optional: true

  has_many_attached :images

  # Scopes
  scope :todays_evidences, ->(user) {
    where(user: user).
    where('created_at BETWEEN ? AND ?', DateTime.now.beginning_of_day, DateTime.now.end_of_day)
  }

  # Methods
  def get_all_images_url
    images.map { |image| ActiveStorage::Blob.service.send(:path_for, image.key) }
  end
  
  def supervisor
    self.user
  end
end
