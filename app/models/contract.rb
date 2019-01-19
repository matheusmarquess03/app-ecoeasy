# frozen_string_literal: true

class Contract < ApplicationRecord
  has_many_attached :attachments

  def get_path_attachments
    attachments.first.service_url
  end
end
