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

json.images_2 evidence.images.first.service_url

json.images_3  do
  evidence.get_all_images_url
end

json.images_4 do
  evidence.images.map do |image|
    image.service_url
  end
end

json.images_5 do
  evidence.images.map do |image|
    url_for(image.service_url)
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
