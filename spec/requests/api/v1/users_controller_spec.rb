# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe API::V1::UsersController, type: :request do
  path '/api/v1/users' do
    let!(:users) { create_list(:user, 2) }
    let(:expected_result) { JSON.parse(API::V1::UserSerializer.new(users).serialize) }

    get I18n.t('api.v1.endpoints.users.index') do
      produces Mime[:json].to_s

      tags User.to_s

      response 200, I18n.t('api.v1.response.ok') do
        after do |example|
          content = example.metadata[:response][:content] || {}

          example_spec = {
            Mime[:json].to_s => {
              example: [
                {
                  id: 1,
                  email: "john@smith.example",
                  firstName: "John",
                  lastName: "Smith",
                  fullName: "John Smith",
                  status: "active",
                  preferences: {
                    theme: 'system'
                  },
                  createdAt: "2024-09-25T10:00:25Z",
                  updatedAt: "2024-09-26T06:12:31Z"
                },
                {
                  id: 2,
                  email: "bruce@wayne.batman",
                  firstName: "Bruce",
                  lastName: "Wayne",
                  fullName: "Bruce Wayne",
                  status: "archived",
                  archivalReason: 'Some reason for account archival',
                  preferences: {
                    theme: 'dark'
                  },
                  createdAt: "2024-09-26T01:20:00Z",
                  updatedAt: "2024-09-26T06:30:30Z"
                }
              ]
            }
          }

          example.metadata[:response][:content] = content.deep_merge(example_spec)
        end

        schema type: :array, items: { '$ref' => '#/components/schemas/user' }

        run_test! do |_response|
          expect(json).to eq(expected_result)
        end
      end
    end
  end
end
