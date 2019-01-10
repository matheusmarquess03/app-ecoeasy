# frozen_string_literal: true

class Contract < ApplicationRecord
  has_many_attached :attachments
end
