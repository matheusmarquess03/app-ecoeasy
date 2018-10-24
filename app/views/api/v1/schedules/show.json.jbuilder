json.id             @schedule.id
json.work_day       @schedule.work_day
json.full_schedule  @schedule.full_schedule
json.collects do
  json.array! @schedule.collects.confirmed do |collect|
    if collect.present?
      json.id               collect.id
      json.status           collect.status
      json.type_collect     collect.type_collect
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
      end
      json.citizen do
        json.id                 collect.client.id
        json.name               collect.client.name
        json.phone_number       collect.client.phone_number
      end
    end
  end
end
