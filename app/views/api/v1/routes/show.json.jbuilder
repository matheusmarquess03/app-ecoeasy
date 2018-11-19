json.id             @route.id
json.date           @route.schedule.work_day
json.address do
  json.array! @route.address do |address|
    json.id                 address.id
    json.district           address.district
    json.city               address.city
    json.state              address.state
    json.country            address.country
    json.latitude           address.latitude.to_f
    json.longitude          address.longitude.to_f
  end
end
