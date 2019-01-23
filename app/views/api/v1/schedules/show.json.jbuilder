json.id             @schedule.id
json.work_day       @schedule.work_day
json.full_schedule  @schedule.full_schedule
json.collects do
  json.array! @schedule.collects.confirmed do |collect|
    if collect.present?
      json.id               collect.id
      json.status           collect.read_attribute_before_type_cast(:status)
      json.type_collect     collect.read_attribute_before_type_cast(:type_collect)
      if collect.daily_garbage_collection?
        json.routes do
          json.title        collect.schedule.routes&.last.title
          json.description  collect.schedule.routes&.last.description
          json.address do
            json.array! collect.schedule.routes&.last.address do |address|
              json.id                 address.id
              json.district           address.district
              json.city               address.city
              json.state              address.state
              json.country            address.country
              json.latitude           address.latitude.to_f
              json.longitude          address.longitude.to_f
            end
          end
        end
      elsif collect.rubble_collect?
        json.address do
          json.id                 collect.address&.id
          json.zip_code           collect.address&.zip_code
          json.street             collect.address&.street
          json.number             collect.address&.number
          json.complement         collect.address&.complement
          json.district           collect.address&.district
          json.city               collect.address&.city
          json.state              collect.address&.state
          json.country            collect.address&.country
          json.latitude           collect.address&.latitude
          json.longitude          collect.address&.longitude
        end
        json.citizen do
          json.id                 collect.client.id
          json.name               collect.client.name
          json.phone_number       collect.client.phone_number
        end
      end
    end
  end
end
