class Client < User
  has_many :addresses, foreign_key: 'user_id', dependent: :destroy
  has_many :collects, foreign_key: 'user_id', dependent: :destroy
  has_many :evidences, foreign_key: 'client_id'
  has_many :contestations, foreign_key: 'user_id', dependent: :destroy

  def addresses
    Address.where(user: self)
  end
end
