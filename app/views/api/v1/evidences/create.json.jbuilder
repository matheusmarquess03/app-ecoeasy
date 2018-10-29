json.id            @evidence.id
json.date          @evidence.created_at
json.description   @evidence.description
json.supervisor do
  json.id             @evidence.user.id
  json.name           @evidence.user.name
  json.email          @evidence.user.email
end
