# Event Radar API

An all in one event management system made easy for the modern era to manage events, attendees, and more.

This is the API only backend application, user facing frontend is available at [Event Radar Web](https://github.com/event-radar/event-radar-web)

Both can be independently deployed and scaled separately.

## Why

Started this project with two purposes

1. Brush up on my Ruby on Rails skills
2. Portfolio project

## Development

### Prerequisites

- Ruby 3+
- Rails 7.2+
- PostgreSQL 16+
- NodeJS 22+

Use docker setup for local development to avoid dealing with dependencies.

### Local development with docker

```bash
docker-compose up --watch

# Or if you want to rebuild everything
docker compose up --watch --remove-orphans --build --force-recreate
```

Rails server will be available on <http://localhost:3000> and Sidekiq on <http://localhost:3000/sidekiq>

Ruby YJIT is enabled by default in docker setup

### Local development without docker

These steps are only for reference, prefer docker based setup for local development.

Install Ruby, Rails, PostgreSQL and Redis locally.
Prefer using rvm to manage ruby versions.
On MacOS with Homebrew is recommended for installing PostgreSQL and Redis.

```bash
# Install dependencies
bundle install
npm install
```

Standard Rails database setup

```bash
rails db:drop
rails db:create
rails db:reset
rails db:prepare
rails db:seed

rails db:migrate
rails db:migrate:with_data
```

Check [Rails documentation](https://api.rubyonrails.org/classes/ActiveRecord/Tasks/DatabaseTasks.html)
for more details or try `rails -T` to see what other commands are available.

Start Rails server

```bash
# Start rails server
rails s

# Separately start Sidekiq
bundle exec sidekiq
```

Rails server will be available on <http://localhost:3000> and Sidekiq on <http://localhost:3000/sidekiq>

### Testing

```bash
rspec
```

Rails console for debugging

```bash
rails c
```

### Code quality and best practices

```bash
# Single point to auto fix all linting issues
# It will also run rubocop
npm run lint:fix

# Execute rubocop manually
# Linting and static code analysis
rubocop -A
```

## API Documentation

TODO: Add Swagger/OpenAPI documentation

## Concepts

Check [Concepts Overview](./docs/concepts/entities.md) for more details.
