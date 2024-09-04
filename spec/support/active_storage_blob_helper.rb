# frozen_string_literal: true

module ActiveStorageBlobHelper
  def create_blob(tempfile, content_type = nil)
    tempfile.rewind
    uploaded_file = ActionDispatch::Http::UploadedFile.new(
      filename: File.basename(tempfile.path), tempfile:
    )

    ActiveStorage::Blob.create_and_upload!(
      io: uploaded_file, filename: File.basename(tempfile.path), content_type:
    )
  end

  def blob_url(blob)
    Rails.application.routes.url_helpers.rails_blob_url(blob)
  end
end
