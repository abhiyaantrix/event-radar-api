# frozen_string_literal: true

module ErrorHandler

  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::RoutingError, with: :handle_error
    rescue_from ActiveRecord::RecordNotFound, with: :handle_error
    rescue_from ActiveRecord::RecordNotSaved, with: :handle_error
    rescue_from ActiveRecord::RecordInvalid, with: :handle_error
    rescue_from ActionController::ParameterMissing, with: :handle_error
    rescue_from ActionController::BadRequest, with: :handle_error

    rescue_from RuntimeError, with: :handle_internal_server_error
    rescue_from StandardError, with: :handle_internal_server_error
  end

  def route_not_found
    raise ActionController::RoutingError
  end

  private

  ERROR_MAPPINGS = {
    ActionController::RoutingError => [ :not_found, 'api.v1.response.errors.routing_error' ].freeze,
    ActiveRecord::RecordNotFound => [ :not_found, 'api.v1.response.errors.record_not_found' ].freeze,
    ActiveRecord::RecordNotSaved => [ :unprocessable_content, 'api.v1.response.errors.record_not_saved' ].freeze,
    ActiveRecord::RecordInvalid => [ :bad_request, 'api.v1.response.errors.record_invalid' ].freeze,
    ActionController::ParameterMissing => [ :bad_request, 'api.v1.response.errors.parameter_missing' ].freeze,
    ActionController::BadRequest => [ :bad_request, 'api.v1.response.errors.bad_request' ].freeze,
    RuntimeError => [ :internal_server_error, 'api.v1.response.errors.runtime_error' ].freeze,
    StandardError => [ :internal_server_error, 'api.v1.response.errors.standard_error' ].freeze
  }.freeze

  def handle_internal_server_error(exception)
    log_exception(exception)

    handle_error(exception)
  end

  # TODO: Send to error tracking system
  # This method smells of :reek:UtilityFunction
  def log_exception(exception)
    backtrace = exception.backtrace
    message = exception.message

    logger = Rails.logger

    logger.error(message)
    logger.error(backtrace.join('\n')) if backtrace
  end

  def handle_error(exception)
    status, i18n_key = ERROR_MAPPINGS.fetch(exception.class, ERROR_MAPPINGS[StandardError])

    respond_with_error(status:, i18n_key:)
  end

  def respond_with_error(status:, i18n_key:, i18n_variables: {})
    render(
      json: {
        error: {
          code: Rack::Utils::SYMBOL_TO_STATUS_CODE.fetch(status),
          key: status.to_s,
          message: I18n.t(i18n_key, **i18n_variables)
        }
      },
      status:
    )
  end

end
