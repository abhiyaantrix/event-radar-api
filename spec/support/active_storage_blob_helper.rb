# frozen_string_literal: true

module ActiveStorageBlobHelper

  def self.create_blob(tempfile, content_type = nil)
    tempfile.rewind
    path = tempfile.path
    filename = File.basename(path)
    uploaded_file = ActionDispatch::Http::UploadedFile.new(
      filename:, tempfile:
    )

    ActiveStorage::Blob.create_and_upload!(
      io: uploaded_file, filename:, content_type:
    )
  end

  def self.blob_url(blob)
    Rails.application.routes.url_helpers.rails_blob_url(blob)
  end

end
