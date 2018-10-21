class Client < User
  has_many :addresses, foreign_key: 'user_id', dependent: :destroy

  def addresses
    Address.where(user: self)
  end
end
