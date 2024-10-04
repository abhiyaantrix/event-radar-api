# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::EventSerializer, type: :serializer do
  subject(:serialized_json) { described_class.new(event).serialize }

  let(:base_expected_data) do
    {
      "id" => event.id,
      "title" => event.title,
      "description" => event.description,
      "status" => event.status,
      "startTime" => event.start_time.iso8601,
      "createdAt" => event.created_at.iso8601,
      "updatedAt" => event.updated_at.iso8601
    }
  end

  context 'when closed ended event' do
    let(:event) { create(:event, :future) }

    let(:expected_data) { base_expected_data.merge("endTime" => event.end_time.iso8601) }

    include_examples 'validate serialized json'
  end

  context 'when open ended event' do
    let(:event) { create(:event, :open_ended) }

    let(:expected_data) { base_expected_data.merge("endTime" => nil) }

    include_examples 'validate serialized json'
  end
end
