# Event Radar API

An all in one event management platform made easy for the modern era to manage events, attendees, and more.

This is the API only backend application, user facing frontend is available at
[Event Radar Web](https://github.com/abhiyaantrix/event-radar-web)

Both can be independently deployed and scaled separately.

## Why

Started this project with these purposes

1. Refresh my Ruby on Rails skills
2. Simple yet comprehensive portfolio project

### Note

This is a side project and is not affiliated with any company.

This project is free of AI written code, just plain old pure human craftsmanship.

However, for certain blockers I have used AI to help me out, for example: incorrect configurations.

For code reviews, [Sourcery AI](https://sourcery.ai/) is used to help catch obvious mistakes.

## Development

### Prerequisites

- Ruby 3+
- Rails 7.2+
- PostgreSQL 16+
- NodeJS 22+
- NPM 10+

Use docker setup for local development to avoid dealing with dependencies.

### Local development with docker

```bash
docker-compose up --watch

# Or if you want to rebuild everything
docker compose up --watch --remove-orphans --build --force-recreate
```

Rails server will be available on <http://localhost:3000> and Sidekiq on <http://localhost:3000/sidekiq>

YJIT is enabled by default in docker setup

### Local development without docker

These steps are only for reference, prefer docker based setup for local development.

Install Ruby, Rails, PostgreSQL and Redis locally.
Prefer using rvm to manage ruby versions and nvm to manage nodejs versions.
On MacOS with Homebrew is recommended for installing PostgreSQL and Redis.

To enable Ruby YJIT install Rust with Homebrew if Ruby is being built from sources.

```bash
brew install rust
```

Install Ruby on MacOS

```bash
rvm install 3.3.5 --docs --with-yjit --with-openssl-dir=$(brew --prefix openssl)
```

Verify YJIT is enabled

```bash
ruby -v
# ruby 3.3.5 (2024-09-03 revision ef084cc8f4) +YJIT [arm64-darwin23]

# or in irb
RubyVM::YJIT.enabled?
```

Install dependencies

```bash
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

#### Debugging

Use Rails console for debugging

```bash
rails c
```

Use [Ruby's Debugger](https://github.com/ruby/debug) with
[pry](https://github.com/pry/pry) for debugging

```bash
binding.pry
```

### Continuous integration

GitHub Actions is used for CI/CD and static code analysis for code style, security vulnerabilities, and best practices.

Check [GitHub Actions](.github/workflows) for more details.

It is triggered on every pull request and push to main or develop branch.
We also skip it for draft pull requests and also concurrency jobs are cancelled.

## Developer Documentation

In addition to this quick start guide, detailed [developer documentation](./docs/developer_guide/) is available,
covering various components and architectural aspects of the platform.

Key sections

- [Architecture Overview](./docs/developer_guide/architecture_overview.md)
  For a comprehensive look at the platform's architecture and design principles

- [Database Design](./docs/developer_guide/database_design_overview.md)
  For an in-depth explanation of the database structure and relationships

## API Documentation

[rswag](https://github.com/rswag/rswag) is used to write API specs and auto-generate OpenAPI v3 documentation.

Each time [API specs](./spec/requests/api) are updated or created, refresh API documentation using

```bash
RAILS_ENV=test RSWAG_DRY_RUN=0 rails rswag PATTERN="spec/requests/api/**/*_spec.rb"
```

[API documentation](./docs/api_guide) is generated docs folder.

## User documentation

Check [User documentation](./docs/user_guide) for more details.
