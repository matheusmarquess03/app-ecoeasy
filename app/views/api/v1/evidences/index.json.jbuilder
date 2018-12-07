json.array! @evidences do |evidence|
  json.id            evidence.id
  json.date          evidence.created_at
  json.description   evidence.description
  json.full_address  evidence.full_address
  json.evidence_type evidence.read_attribute_before_type_cast(:evidence_type)

  json.images do
    json.array! evidence.get_all_images_url
  end

  json.supervisor do
    json.id             evidence.user.id
    json.name           evidence.user.name
    json.email          evidence.user.email
  end
end
