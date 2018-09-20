class Trucker < User
  has_many :schedule, dependent: :destroy
end
