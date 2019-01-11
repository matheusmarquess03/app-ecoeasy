json.id          @contract.id
json.name        @contract.name
json.observation @contract.observation
json.attachments @contract.attachments do |attachment|
  json.filename attachment.filename
  json.url      url_for(attachment)
  json.size     number_to_human_size(attachment.blob.byte_size)
end
