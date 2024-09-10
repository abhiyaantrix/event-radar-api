# frozen_string_literal: true

class HashSerializer

  def self.dump(value)
    return if value.nil?

    unless value.is_a?(Hash) || value.is_a?(String)
      raise SerializationTypeMismatch,
            "Expected 'Hash' or 'String' value but got #{value.class} => #{value.inspect}"
    end

    value.is_a?(String) ? ActiveSupport::JSON.decode(value) : value
  rescue JSON::ParserError => e
    Rails.logger.error("Error loading JSON! Error: #{e.message}, value: #{value}")

    value # validator will handle this
  end

  def self.load(value)
    return value unless value.present? && value.is_a?(Hash)

    (value || {}).with_indifferent_access
  end

end
