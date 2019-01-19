# frozen_string_literal: true

class Contract < ApplicationRecord
  has_many_attached :attachments

  def get_path_attachments
    ActiveStorage::Blob.service.send(:path_for, attachments.first.key)
  end
end
