json.array! @addresses do |address|
  json.id                 address.id
  json.zip_code           address.zip_code
  json.street             address.street
  json.number             address.number
  json.complement         address.complement
  json.district           address.district
  json.city               address.city
  json.state              address.state
  json.country            address.country
  json.latitude           address.latitude
  json.longitude          address.longitude
  json.default            address.default
end
