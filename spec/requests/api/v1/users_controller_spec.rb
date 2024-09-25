# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/api/v1/users' do
    let!(:users) { create_list(:user, 4) }
    let(:expected_result) { JSON.parse(API::V1::UserSerializer.new(users).serialize) }

    get I18n.t('api.v1.endpoints.users.index') do
      produces Mime[:json].to_s

      tags User.to_s

      response(200, I18n.t('api.v1.response.ok')) do
        after do |example|
          example.metadata[:response][:content] = {
            Mime[:json].to_s => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end

        schema type: :array, items: { '$ref' => '#/components/schemas/user' }

        run_test! do |_response|
          expect(json).to eq(expected_result)
        end
      end
    end
  end
end
