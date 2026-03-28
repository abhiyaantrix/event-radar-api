# Event Radar API - AI Agent Guide

## Architecture Overview

Rails 7.2 API-only application managing events with organizers and online/offline meetings.
Uses PostgreSQL (SQL schema), Redis, Sidekiq for background jobs. Alba serializers output lowerCamelCase JSON.

Key components:

- **Models**: Events, Users, OnlineMeetings, OfflineMeetings with state machines
- **Controllers**: API::V1 namespace, inherit from BaseController with ErrorHandler concern
- **Serializers**: Inherit from BaseSerializer, include TimestampsFormatter for ISO8601 timestamps
- **Jobs**: Sidekiq for async tasks

## Development Workflow

- **Run locally**: `docker compose up` (preferred) or `bin/rails server` + `bundle exec sidekiq`
- **Tests**: `bundle exec rspec spec/models/` or `spec/requests/`; uses VCR for HTTP mocks
- **Code quality**: `bundle exec rubocop -a`, `brakeman`, `reek app/`, `bundle-audit check`, `rake traceroute`
- **DB setup**: `bin/rails db:create db:schema:load` (uses `db/structure.sql`)
- **API docs**: `RAILS_ENV=test rails rswag` generates OpenAPI in `docs/api_guide/`

## Project Conventions

- **Enums**: Integer in DB, string keys (e.g., `enum :status, { draft: 0, published: 1 }`)
- **State machines**: Include `SimpleStateMachine` concern, define `ALLOWED_STATUS_TRANSITIONS` hash
  (see `app/models/event.rb`)
- **JSONB fields**: Use `serialize :preferences, coder: HashSerializer` and `store_accessor`
  (see `app/models/user.rb`)
- **Validations**: Always use `TimeRangeValidator` for start/end times; custom validators in `app/validators/`
- **Error handling**: Controllers include `ErrorHandler` concern mapping exceptions to JSON responses
  (see `app/controllers/concerns/error_handler.rb`)
- **Serialization**: Attributes in lowerCamelCase; timestamps via `timestamps :created_at, :updated_at`
  (see `app/serializers/api/v1/event_serializer.rb`)
- **Testing**: Request specs with rswag generate OpenAPI; use FactoryBot, VCR cassettes; Bullet N+1 detection enabled

## Key Files

- `CLAUDE.md`: Detailed project guide
- `app/models/concerns/simple_state_machine.rb`: Reusable state transition logic
- `app/controllers/api/v1/base_controller.rb`: Base for all API controllers
- `app/serializers/base_serializer.rb`: Alba base with camelCase transform
- `app/serializers/concerns/timestamps_formatter.rb`: ISO8601 timestamp formatting
- `db/structure.sql`: Database schema (use `db:schema:load`)
