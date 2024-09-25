# frozen_string_literal: true

module JsonHelper

  def json
    @json ||= begin
      body = response.body

      if response.status == 204
        return {}
      elsif body.blank?
        raise "Blank response body"
      else
        JSON.parse(body)
      end
    rescue JSON::ParserError
      raise "Invalid JSON response body: #{body}"
    end
  end

  def json_symbolize
    @json_symbolize ||= begin
      if json.is_a?(Hash)
        json.deep_symbolize_keys
      elsif json.is_a?(Array)
        json.map { |item| item.is_a?(Hash) ? item.deep_symbolize_keys : item }
      else
        json
      end
    end
  end

end
