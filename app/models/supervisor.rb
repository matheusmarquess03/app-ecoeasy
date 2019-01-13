class Supervisor < User
  has_many :evidences, foreign_key: 'user_id'

  def firebase_reference_access
    "#{Date.current.strftime('%Y-%m-%d')}/#{id}"
  end
end
