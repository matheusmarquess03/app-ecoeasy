class Evidence < ApplicationRecord
  belongs_to :user
  belongs_to :address, optional: true

  has_many_attached :images

  def supervisor
    self.user
  end
end
