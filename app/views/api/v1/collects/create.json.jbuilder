json.id               @collect.id
json.status           @collect.read_attribute_before_type_cast(:status)
json.type_collect     @collect.read_attribute_before_type_cast(:type_collect)
json.address do
  json.id                 @collect.address.id
  json.zip_code           @collect.address.zip_code
  json.street             @collect.address.street
  json.number             @collect.address.number
  json.complement         @collect.address.complement
  json.district           @collect.address.district
  json.city               @collect.address.city
  json.state              @collect.address.state
  json.country            @collect.address.country
  json.latitude           @collect.address.latitude.to_f
  json.longitude          @collect.address.longitude.to_f
end
