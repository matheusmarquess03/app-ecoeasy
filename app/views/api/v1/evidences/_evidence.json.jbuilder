json.id            evidence.id
json.date          evidence.created_at
json.description   evidence.description
json.full_address  evidence.full_address
json.evidence_type evidence.read_attribute_before_type_cast(:evidence_type)

json.images_2 evidence.images.first.service_url

if evidence.signature.attached?
  json.signature url_for(evidence.signature&.service_url)
else
  json.signature nil
end

json.supervisor do
  json.id             evidence.user.id
  json.name           evidence.user.name
  json.email          evidence.user.email
end
