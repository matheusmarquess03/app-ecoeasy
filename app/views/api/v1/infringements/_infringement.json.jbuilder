json.id            infringement.id
json.date          infringement.created_at
json.description   infringement.description
json.full_address  infringement.full_address
json.evidence_type infringement.read_attribute_before_type_cast(:evidence_type)
json.mulct_value   infringement.mulct_value
json.boleto        url_for(Contract.first&.attachments.first.service_url)

json.images        url_for(infringement.images&.first&.service_url)

json.citizen do
  json.id             infringement.client.id
  json.name           infringement.client.name
  json.email          infringement.client.email
  json.cpf            infringement.client.cpf
end

json.supervisor do
  json.name           infringement.supervisor&.name
end
