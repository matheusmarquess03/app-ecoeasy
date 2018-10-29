class Evidence < ApplicationRecord
  belongs_to :user
  belongs_to :address, optional: true
end
