json.array! @infringements do |infringement|
  json.id            infringement.id
  json.date          infringement.created_at
  json.description   infringement.description
  json.full_address  infringement.full_address
  json.evidence_type infringement.read_attribute_before_type_cast(:evidence_type)

  json.images do
    json.array! infringement.get_all_images_url
  end

  json.client do
    json.id             infringement.client.id
    json.name           infringement.client.name
    json.email          infringement.client.email
  end
end
