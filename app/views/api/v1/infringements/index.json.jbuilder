json.array! @infringements do |infringement|
  json.id            infringement.id
  json.date          infringement.created_at
  json.description   infringement.description
  json.full_address  infringement.full_address
  json.evidence_type infringement.read_attribute_before_type_cast(:evidence_type)
  json.mulct_value   infringement.mulct_value
  json.boleto        url_for(Contract.first&.attachments.first.service_url)

  json.images do
    json.array! infringement.images do |image|
      url_for(image.service_url)
    end
  end

  json.citizen do
    json.id             infringement.client.id
    json.name           infringement.client.name
    json.email          infringement.client.email
    json.cpf            infringement.client.cpf
  end
end
