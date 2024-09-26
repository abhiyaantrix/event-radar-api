# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::UserSerializer, type: :serializer do
  subject(:serialized_json) { JSON.parse(described_class.new(user).serialize) }

  let(:user) { create(:user, preferences: { theme: 'dark' }) }

  let(:expected_user_data) do
    {
      "id" => user.id,
      "firstName" => user.first_name,
      "lastName" => user.last_name,
      "fullName" => user.full_name,
      "email" => user.email,
      "status" => user.status,
      "preferences" => { "theme" => "dark" },
      "createdAt" => user.created_at.iso8601,
      "updatedAt" => user.updated_at.iso8601
    }
  end

  it 'includes expected attributes' do
    expect(serialized_json).to eq(expected_user_data)
  end
end
