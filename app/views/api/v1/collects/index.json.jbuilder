json.array! @collects do |collect|
  json.id               collect.id
  json.status           collect.read_attribute_before_type_cast(:status)
  json.type_collect     collect.read_attribute_before_type_cast(:type_collect)
  json.collect_date     collect.collect_date&.strftime("%Y/%m/%d")
  json.address do
    json.id                 collect.address.id
    json.zip_code           collect.address.zip_code
    json.street             collect.address.street
    json.number             collect.address.number
    json.complement         collect.address.complement
    json.district           collect.address.district
    json.city               collect.address.city
    json.state              collect.address.state
    json.country            collect.address.country
    json.latitude           collect.address.latitude
    json.longitude          collect.address.longitude
  end
end
