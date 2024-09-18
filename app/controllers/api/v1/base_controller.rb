# frozen_string_literal: true

module API
  module V1
    class BaseController < ApplicationController

      # TODO: Authentication
      # TODO: Authorization
      # TODO: Handle Errors
      # TODO: Render JSON

      before_action :ensure_json_request_format

      private

      def ensure_json_request_format
        unless request.format.json?
          render json: { message: I18n.t('errors.request.format.only_json_accepted') }, status: :not_acceptable
        end
      end

    end
  end
end
