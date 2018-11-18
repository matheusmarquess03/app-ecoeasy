json.array! @landfills do |landfill|
  json.id               landfill.id
  json.name             landfill.name
  json.address do
    json.id                 landfill.address&.id
    json.zip_code           landfill.address&.zip_code
    json.street             landfill.address&.street
    json.number             landfill.address&.number
    json.complement         landfill.address&.complement
    json.district           landfill.address&.district
    json.city               landfill.address&.city
    json.state              landfill.address&.state
    json.country            landfill.address&.country
    json.latitude           landfill.address&.latitude
    json.longitude          landfill.address&.longitude
  end
end
