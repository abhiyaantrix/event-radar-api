# frozen_string_literal: true

module API
  module V1
    class BaseController < ApplicationController

      # TODO: Authentication
      # TODO: Authorization
      # TODO: Handle Errors
      # TODO: Render JSON

      # Depending on API V2 design, this can be moved to Application controller as needed
      include ErrorHandler
      include Versionable

      before_action :ensure_json_request_format

      private

      def ensure_json_request_format
        unless request.format.json?
          respond_with_error(status: :not_acceptable, i18n_key: 'api.v1.request.errors.format.only_json_accepted')
        end
      end

    end
  end
end
