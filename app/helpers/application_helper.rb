module ApplicationHelper
  def password_placeholder(object)
    return 'Deixe em branco para não mudar a senha' if object.persisted?
  end

  def address_formatted_to_maps(address)
    address_formatted = ''
    address_formatted += "#{address.street}, "   if address.street.present?
    address_formatted += "#{address.number} - "  if address.number.present?
    address_formatted += "#{address.district}, " if address.district.present?
    address_formatted += "#{address.city}, "     if address.city.present?
    address_formatted += "#{address.state} - "     if address.state.present?
    address_formatted += "#{address.zip_code} - "     if address.zip_code.present?
    address_formatted += "#{address.country}"     if address.country.present?

    return address_formatted
  end
end
