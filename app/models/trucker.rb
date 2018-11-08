class Trucker < User

  # Methods
  def collects
    Collect.where(user: self)
  end
end
