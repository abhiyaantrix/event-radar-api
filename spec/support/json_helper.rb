# frozen_string_literal: true

module JsonHelper

  def json
    @json ||= JSON.parse(response.body) if response.body.present?
  end

  def json_symbolize
    @json_symbolize ||= JSON.parse(response.body, symbolize_names: true) if response.body.present?
  end

end
