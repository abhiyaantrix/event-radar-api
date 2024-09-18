# frozen_string_literal: true

module ErrorHandler

  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_error

    def route_not_found
      raise ActionController::RoutingError
    end
  end

  private

  ERROR_MAPPINGS = {
    StandardError => [ :internal_server_error, 'api.v1.errors.response.internal_server_error' ].freeze,
    RuntimeError => [ :internal_server_error, 'api.v1.errors.response.internal_server_error' ].freeze,
    ActiveRecord::RecordNotFound => [ :not_found, 'api.v1.errors.response.record_not_found' ].freeze,
    ActiveRecord::RecordNotSaved => [ :unprocessable_content, 'api.v1.errors.response.unprocessable_content' ].freeze,
    ActiveRecord::RecordInvalid => [ :bad_request, 'api.v1.errors.response.bad_request' ].freeze,
    ActionController::ParameterMissing => [ :bad_request, 'api.v1.errors.response.bad_request' ].freeze,
    ActionController::RoutingError => [ :not_found, 'api.v1.errors.response.record_not_found' ].freeze
  }.freeze

  def handle_error(exception)
    status, i18n_key = ERROR_MAPPINGS.fetch(exception.class, ERROR_MAPPINGS[StandardError])

    respond_with_error(status: status, i18n_key: i18n_key)
  end

  def respond_with_error(status:, i18n_key:)
    render(
      json: {
        error: {
          code: Rack::Utils::SYMBOL_TO_STATUS_CODE.fetch(status),
          status: status.to_s,
          message: I18n.t(i18n_key)
        }
      },
      status: status
    )
  end

end
