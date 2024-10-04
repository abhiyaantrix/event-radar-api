# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe API::V1::EventsController, type: :request do
  path '/api/v1/events' do
    let!(:events) do
      [
        create(:event, :future),
        create(:event, :past),
        create(:event, :ongoing),
        create(:event, :open_ended)
      ]
    end

    let(:expected_data) { JSON.parse(API::V1::EventSerializer.new(events).serialize) }

    get I18n.t('api.v1.endpoints.events.index') do
      produces Mime[:json].to_s

      tags Event.to_s

      response 200, I18n.t('api.v1.response.ok') do
        after do |example|
          example_data = [
            {
              id: 1,
              title: 'Ruby Meetup - October 2024',
              description: "Ruby developer group's monthly meetup",
              status: 'published',
              startTime: '2024-10-25T10:00:25Z',
              createdAt: '2024-09-25T10:00:25Z',
              updatedAt: '2024-09-26T06:12:31Z'
            },
            {
              id: 2,
              title: 'Ruby Meetup - November 2024',
              description: "Ruby developer group's monthly meetup",
              status: 'draft',
              startTime: '2024-11-25T10:00:25Z',
              endTime: '2024-11-25T10:00:25Z',
              createdAt: '2024-10-25T10:00:25Z',
              updatedAt: '2024-10-26T06:12:31Z'
            }
          ]

          add_response_example(example, example_data)
        end

        schema type: :array, items: { '$ref' => '#/components/schemas/event' }

        run_test! do
          expect(json).to eq(expected_data)
        end
      end
    end
  end

  path '/api/v1/events/{event_id}' do
    let!(:event) { create(:event, :future, status: :published) }
    let(:event_id) { event.id }

    let(:expected_data) { JSON.parse(API::V1::EventSerializer.new(event).serialize) }

    get I18n.t('api.v1.endpoints.events.show') do
      produces Mime[:json].to_s

      tags Event.to_s

      parameter '$ref' => '#/components/parameters/event_id'

      response 200, I18n.t('api.v1.response.ok') do
        after do |example|
          example_data = {
            id: 1,
            title: 'Ruby Meetup - November 2024',
            description: "Ruby developer group's monthly meetup",
            status: 'published',
            startTime: '2024-11-25T10:00:25Z',
            createdAt: '2024-10-25T10:00:25Z',
            updatedAt: '2024-10-26T06:12:31Z'
          }

          add_response_example(example, example_data)
        end

        schema '$ref' => '#/components/schemas/event'

        run_test! do
          puts "json: #{json}"
          expect(json).to eq(expected_data)
        end
      end
    end
  end
end
