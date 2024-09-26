# frozen_string_literal: true

require 'rails_helper'

# Intentionally kept as an example
# API specs should be written with Rswag, see 'spec/requests/api/v1/users_controller_spec.rb'
RSpec.describe API::V1::UsersController, type: :request do
  describe '#index' do
    subject(:get_users) { get api_v1_users_path }

    let!(:users) { create_list(:user, collection_size) }

    let(:collection_size) { 4 }

    let(:expected_keys) do
      [
        :id,
        :email,
        :firstName,
        :lastName,
        :fullName,
        :status,
        :preferences,
        :createdAt,
        :updatedAt
      ]
    end

    describe 'response' do
      before { get_users }

      it 'responds with http success' do
        expect(response).to be_successful
      end

      it 'serializes users collection with expected attributes' do
        users = json_symbolize

        expect(users.size).to eq(collection_size)
        expect(users.first.keys).to match_array(expected_keys)
      end
    end

    context 'when user is archived' do
      let(:archival_reason) { 'dummy reason' }
      let!(:archived_user) { create(:user, status: :archived, archival_reason:) }

      it 'includes archival_reason in the serialized output' do
        get_users

        archived_user_json = json_symbolize.find { |user| user[:id] == archived_user.id }

        expect(archived_user_json[:status]).to eq(archived_user.status)
        expect(archived_user_json).to have_key(:archivalReason)
        expect(archived_user_json[:archivalReason]).to eq(archival_reason)
      end
    end
  end
end
