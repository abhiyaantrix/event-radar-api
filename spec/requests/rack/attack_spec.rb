# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rack::Attack do
  around do |example|
    described_class.reset!
    described_class.enabled = true
    cache_store_was = Rails.cache
    described_class.cache.store = ActiveSupport::Cache::MemoryStore.new

    example.run

    described_class.enabled = false
    described_class.cache.store = cache_store_was
  end

  it 'throttles request' do
    headers = { 'ACCEPT' => 'application/json' }
    stub_const('Rack::Attack::LIMIT_PER_IP', 2)

    get('/up', headers:)
    get('/up', headers:)

    expect(response).to have_http_status(:ok)

    get('/up', headers:)

    expect(response).to have_http_status(:too_many_requests)
    expect(response.parsed_body).to eq("{\"message\":\"Throttled\"}\n")

    expect(response.headers['RateLimit-Limit']).to eq('2')
    expect(response.headers['RateLimit-Remaining']).to eq('0')
  end
end
