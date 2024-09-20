# frozen_string_literal: true

module Versionable

  extend ActiveSupport::Concern

  class APIVersionMismatchError < StandardError; end

  included do
    before_action :set_api_version
    before_action :ensure_api_version
  end

  private

  attr_reader :api_version

  def set_api_version
    @api_version ||= begin
      # /api/v1/users -> ['', 'api', 'v1', 'users'] -> 'v1'
      version = request.path.split('/').third

      APIVersion.new(version)
    end
  end

  def ensure_api_version
    unless api_version.valid? && api_version.public_send("#{expected_api_version}?")
      handle_version_mismatch
    end
  end

  def expected_api_version
    @expected_api_version ||= self.class.module_parent.name.split('::').second.downcase
  end

  def handle_version_mismatch
    version = api_version.version

    if Rails.env.local?
      raise APIVersionMismatchError,
        "Controller version mismatch: expected #{expected_api_version}, but got #{version}"
    else
      Rails.logger.error(
        "Controller version mismatch: expected #{expected_api_version}, but got #{version}"
      )

      raise ActionController::BadRequest
    end
  end

end
