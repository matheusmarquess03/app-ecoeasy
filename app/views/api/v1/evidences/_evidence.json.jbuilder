json.id            evidence.id
json.date          evidence.created_at
json.description   evidence.description
json.full_address  evidence.full_address
json.evidence_type evidence.read_attribute_before_type_cast(:evidence_type)

json.images do
  json.array! evidence.images do |image|
    url_for(image&.service_url)
  end
end

json.images do
  json.array! evidence.images do |image|
    Rails.application.routes.url_helpers.rails_blob_path(evidence.image, only_path: true)
  end
end


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
