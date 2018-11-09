module ApplicationHelper
  def password_placeholder(object)
    return 'Deixe em branco para não mudar a senha' if object.persisted?
  end
end
