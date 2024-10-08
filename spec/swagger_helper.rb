# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.include SwaggerHelpers

  config.openapi_root = Rails.root.join('docs', 'api_guide').to_s

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/open_api.yaml' => {
      openapi: '3.0.3',
      info: {
        title: I18n.t('api.v1.info.title'),
        description: I18n.t('api.v1.info.description'),
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'www.example.com'
            }
          }
        }
      ],
      components: {
        parameters: {
          event_id: {
            name: :event_id,
            in: :path,
            required: true,
            schema: {
              type: :string
            },
            description: I18n.t('api.v1.models.event.id.description')
          }
        },
        schemas: {
          error: {
            type: :object,
            required: %i[error],
            properties: {
              error: {
                type: :object,
                required: %i[code key message],
                properties: {
                  code: {
                    type: :integer,
                    description: I18n.t('api.v1.response.errors.code.description')
                  },
                  key: {
                    type: :string,
                    minLength: 1,
                    description: I18n.t('api.v1.response.errors.key.description')
                  },
                  message: {
                    type: :string,
                    minLength: 1,
                    description: I18n.t('api.v1.response.errors.message.description')
                  }
                }
              }
            }
          },
          user: {
            type: :object,
            required: %I[id email firstName lastName fullName status preferences createdAt updatedAt],
            properties: {
              id: {
                type: :integer,
                minimum: 1,
                description: I18n.t('api.v1.models.user.id.description')
              },
              email: {
                type: :string,
                minLength: 1,
                maxLength: EventRadar::Config::VARCHAR_MAX_LENGTH,
                description: I18n.t('api.v1.models.user.email.description')
              },
              firstName: {
                type: :string,
                minLength: 1,
                maxLength: EventRadar::Config::VARCHAR_MAX_LENGTH,
                description: I18n.t('api.v1.models.user.first_name.description')
              },
              lastName: {
                type: :string,
                minLength: 1,
                maxLength: EventRadar::Config::VARCHAR_MAX_LENGTH,
                description: I18n.t('api.v1.models.user.last_name.description')
              },
              fullName: {
                type: :string,
                minLength: 0,
                maxLength: EventRadar::Config::TEXT_MAX_LENGTH,
                description: I18n.t('api.v1.models.user.full_name.description')
              },
              status: {
                type: :string,
                enum: User.statuses.keys,
                description: I18n.t('api.v1.models.user.status.description')
              },
              archivalReason: {
                type: :string,
                nullable: true,
                minLength: 0,
                maxLength: EventRadar::Config::VARCHAR_MAX_LENGTH,
                description: I18n.t('api.v1.models.user.archival_reason.description')
              },
              preferences: {
                type: :object,
                additionalProperties: false,
                properties: {
                  theme: {
                    type: :string,
                    minLength: 1,
                    description: I18n.t(
                      'api.v1.models.user.preferences.theme.description',
                      themes: EventRadar::Config.themes.join(', ')
                    )
                  }
                }
              },
              createdAt: {
                type: :string,
                description: I18n.t('api.v1.models.user.created_at.description')
              },
              updatedAt: {
                type: :string,
                description: I18n.t('api.v1.models.user.updated_at.description')
              }
            }
          },
          event: {
            type: :object,
            required: %I[id title description status startTime endTime createdAt updatedAt],
            properties: {
              id: {
                type: :integer,
                minimum: 1,
                description: I18n.t('api.v1.models.event.id.description')
              },
              title: {
                type: :string,
                minLength: 1,
                maxLength: EventRadar::Config::VARCHAR_MAX_LENGTH,
                description: I18n.t('api.v1.models.event.title.description')
              },
              description: {
                type: :string,
                minLength: 1,
                maxLength: EventRadar::Config::VARCHAR_MAX_LENGTH,
                description: I18n.t('api.v1.models.event.description.description')
              },
              status: {
                type: :string,
                enum: Event.statuses.keys,
                description: I18n.t('api.v1.models.event.status.description')
              },
              startTime: {
                type: :string,
                description: I18n.t('api.v1.models.event.start_time.description')
              },
              endTime: {
                type: :string,
                nullable: true,
                description: I18n.t('api.v1.models.event.end_time.description')
              },
              createdAt: {
                type: :string,
                description: I18n.t('api.v1.models.event.created_at.description')
              },
              updatedAt: {
                type: :string,
                description: I18n.t('api.v1.models.event.updated_at.description')
              }
            }
          }
        }
      }
    }
  }
end
