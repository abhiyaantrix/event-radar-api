# frozen_string_literal: true

class HashSerializer

  def self.dump(value)
    validate_value_type(value)
    decode_value(value)
  rescue JSON::ParserError => error
    handle_json_error(error, value)
  end

  def self.load(value)
    return value unless value.present? && value.is_a?(Hash)

    (value || {}).with_indifferent_access
  end

  def self.decode_value(value)
    value.is_a?(String) ? ActiveSupport::JSON.decode(value) : value
  end

  def self.validate_value_type(value)
    unless value.is_a?(Hash) || value.is_a?(String)
      raise SerializationTypeMismatch,
        "Expected 'Hash' or 'String' value but got #{value.class} => #{value.inspect}"
    end
  end

  def self.handle_json_error(error, value)
    # TODO: Report this to error tracking service
    Rails.logger.error("Error loading JSON! Error: #{error.message}, value: #{value}")

    value # validator will handle this
  end

end
