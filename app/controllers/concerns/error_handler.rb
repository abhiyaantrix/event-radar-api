# frozen_string_literal: true

module ErrorHandler

  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_error
  end

  def route_not_found
    raise ActionController::RoutingError
  end

  private

  ERROR_MAPPINGS = {
    StandardError => [ :internal_server_error, 'api.v1.response.errors.standard_error' ].freeze,
    RuntimeError => [ :internal_server_error, 'api.v1.response.errors.runtime_error' ].freeze,
    ActionController::BadRequest => [ :bad_request, 'api.v1.response.errors.bad_request' ].freeze,
    ActiveRecord::RecordNotFound => [ :not_found, 'api.v1.response.errors.record_not_found' ].freeze,
    ActiveRecord::RecordNotSaved => [ :unprocessable_content, 'api.v1.response.errors.record_not_saved' ].freeze,
    ActiveRecord::RecordInvalid => [ :bad_request, 'api.v1.response.errors.record_invalid' ].freeze,
    ActionController::ParameterMissing => [ :bad_request, 'api.v1.response.errors.parameter_missing' ].freeze,
    ActionController::RoutingError => [ :not_found, 'api.v1.response.errors.routing_error' ].freeze
  }.freeze

  def handle_error(exception)
    status, i18n_key = ERROR_MAPPINGS.fetch(exception.class, ERROR_MAPPINGS[StandardError])

    respond_with_error(status: status, i18n_key: i18n_key)
  end

  def respond_with_error(status:, i18n_key:, i18n_variables: {})
    render(
      json: {
        error: {
          code: Rack::Utils::SYMBOL_TO_STATUS_CODE.fetch(status),
          status: status.to_s,
          message: I18n.t(i18n_key, **i18n_variables)
        }
      },
      status:
    )
  end

end
