class Supervisor < User
  has_many :evidences, foreign_key: 'user_id'
end
