# Event Radar API — Claude Guide

## Project Overview

Rails 7.2 API-only application for managing events. PostgreSQL + Redis + Sidekiq stack.
Currently in early development with read-only endpoints implemented.

- **Ruby**: 3.3.5 (YJIT enabled by default)
- **Rails**: 7.2.1 (API-only)
- **DB**: PostgreSQL 16 (SQL schema format — `db/structure.sql`)
- **Queue**: Sidekiq 7 with Redis 7
- **Serializers**: Alba (camelCase key output)

## Running the Project

### Preferred: Docker Compose

```sh
docker compose up
```

### Local (no Docker)

```sh
bundle install
bin/rails db:setup
bin/rails server
```

## Running Tests

```sh
bundle exec rspec                # full suite
bundle exec rspec spec/models/   # models only
bundle exec rspec spec/requests/ # API request specs
```

Test environment uses:

- Database transactions via `database_cleaner`
- Sidekiq in fake mode
- Rack::Attack disabled
- WebMock blocks external HTTP (use VCR cassettes)
- Bullet N+1 detection enabled

## API Structure

All endpoints are under `/api/v1/`. Responses use lowerCamelCase keys.

Current endpoints:

```text
GET /api/v1/events        # list events
GET /api/v1/events/:id    # single event
GET /api/v1/users         # list users
GET /up                   # health check
```

OpenAPI docs served at `/docs/api`.

## Code Conventions

### Models

- Enums use string type, defined in model
- State machine via `SimpleStateMachine` concern — define `ALLOWED_STATUS_TRANSITIONS`
- JSONB fields use Hash serializer
- Always validate via `TimeRangeValidator` when start/end times are present

### Controllers

- Inherit from `API::V1::BaseController`
- Error handling via `ErrorHandler` concern (maps exceptions to JSON responses)
- Format enforcement: JSON only

### Serializers

- Inherit from `API::V1::BaseSerializer` (Alba-based, lowerCamelCase auto-transform)
- Include `TimestampsFormatter` concern for timestamp attributes

### Testing

- Use factories (FactoryBot), not fixtures
- Request specs should generate OpenAPI docs via rswag
- Use `shoulda-matchers` for association and validation assertions
- VCR cassettes for external HTTP calls

## Code Quality (run before pushing)

```sh
bundle exec rubocop -a         # auto-fix style
bundle exec brakeman           # security scan
bundle exec reek app/          # code smell detection
bundle exec rake traceroute    # unused routes check
bundle exec bundle-audit check # dependency vulnerabilities
```

CI runs all of these automatically on PRs.

## Database

Schema format is **SQL** (`db/structure.sql`). Rails handles this automatically:

```sh
bin/rails db:create db:schema:load # fresh setup
bin/rails db:migrate               # apply new migrations
```

Extensions: `pg_trgm` (trigram text search on users).

## Key Patterns

- `app/concerns/simple_state_machine.rb` — reusable state machine for status enums
- `app/validators/` — custom ActiveModel validators
- `app/serializers/concerns/timestamps_formatter.rb` — shared timestamp formatting
- `ErrorHandler` concern in controllers — centralized exception → HTTP mapping

## TODOs / Not Yet Implemented

- Authentication & authorization (JWT or sessions)
- Pagination, filtering, sorting on list endpoints
- Zoom/Google Meet/Teams integration for OnlineMeeting
- Address/maps validation for OfflineMeeting
- Sidekiq Web UI access control (admin constraints)
- Rate limit alert subscriptions
