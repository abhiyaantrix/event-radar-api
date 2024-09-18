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
    @json_symbolize ||= json.deep_symbolize_keys
  end

  def json_with_indifferent_access
    @json_with_indifferent_access ||= json.with_indifferent_access
  end

end
