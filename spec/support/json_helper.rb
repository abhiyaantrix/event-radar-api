# frozen_string_literal: true

module JsonHelper

  def json
    @json ||= begin
      body = response.body
      JSON.parse(body) if body.present?
    end
  end

  def json_symbolize
    @json_symbolize ||= begin
      body = response.body
      JSON.parse(body, symbolize_names: true) if body.present?
    end
  end

end
