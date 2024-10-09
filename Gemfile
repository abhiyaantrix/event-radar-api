# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.5'

gem 'rails', '~> 7.2.1'
gem 'rake', '~> 13.2.1'
gem 'puma', '>= 6.4.2' # Web server

# Database
gem 'pg', '>= 1.5.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '>= 5.3.0'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

## Background processing
# Simple, efficient background processing for Ruby
gem 'sidekiq', '~> 7.3.2'
# Lightweight job scheduler extension for Sidekiq
gem 'sidekiq-scheduler', '~> 5.0.6'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.20"

# Validate ActiveStorage attachments
gem 'active_storage_validations', '~> 1.2.0'

# Email validation
gem 'valid_email2', '~> 5.3'

# Annotates Rails/ActiveRecord Models, routes, fixtures, and others based on the database schema
gem 'annotate'

# JSON Serialization
gem 'alba', '~> 3.3'
gem 'oj', '~> 3.16.6'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false
# Track changes to ActiveRecord models, for auditing or versioning
# gem 'paper_trail',~> 15.1.015' # Not compatible with Rails 7.2 yet

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.13.0"

# Rack middleware for blocking & throttling
# Configure at config/initializers/rack_attack.rb
gem 'rack-attack', '~> 6.7'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem 'rack-cors', '~> 2.0.2'

# Migrate data across all envs alongside schema migrations
gem 'data_migrate', '~> 11.0.0'

# Catch unsafe migrations in development
gem 'strong_migrations'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# OpenAPI/Swagger
gem 'rswag-api'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug'
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-nav'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  # gem 'pry-theme', '~> 1.3.1'
  # gem 'pry-inline'
  # gem 'pry-coolline', '~> 0.2.6'
  # gem 'pry-clipboard', '~> 0.1.1'
  # gem 'pry-awesome_print', '~> 9.6.11'

  # Tests
  gem 'rspec'
  gem 'rspec-parameterized'
  gem 'rspec-rails'
  # Write Request specs with OpenAPI documentation
  gem 'rswag-specs'
  # Simple one-liner tests for common Rails functionality
  gem 'shoulda-matchers'
  # Test data and mocks
  gem 'factory_bot_rails'
  # Show factory bot calls in test output
  gem 'factory_trace'
  # Generate fake data
  gem 'faker'
  # Time manipulation for testing
  gem 'timecop'
  # Library for stubbing and setting expectations on HTTP requests
  gem 'webmock'
  # Record and replay HTTP requests
  gem 'vcr'

  # Strategies for cleaning databases to ensure clean state for testing suits
  gem 'database_cleaner-active_record'

  # Code coverage
  # gem 'codecov', '~> 0.6', require: false
  gem 'simplecov', require: false
  gem 'simplecov-cobertura', require: false
  gem 'simplecov-console', require: false

  # Kills postgres connections during db:reset so you don't have to restart your server. Fixes "database in use" errors.
  gem 'pgreset'

  # ruby-prof is a profiler for MRI Ruby
  gem 'ruby-prof'
  gem 'stackprof'

  # Code quality tools

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem 'rubocop-rails-omakase', require: false
  gem 'rubocop'
  gem 'rubocop-factory_bot'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
  gem 'rubocop-rspec_rails'

  # Code metric tool
  gem 'rails_best_practices', require: false
  # Detects N+1 queries and unused eager loading
  gem 'bullet'
  # Code smell detector for Ruby
  gem 'reek'
  # Patch-level verification for Bundler
  gem 'bundler-audit', require: false
  # Rake task gem that finds unused routes and controller actions
  gem 'traceroute'
end

group :development do
  # Process manager for applications with multiple components
  gem 'foreman'
  # Rails console replacement, renders error with more info: stacktrace, link to SC, REPL
  gem 'better_errors'
  # Provides REPL for better_errors
  gem 'binding_of_caller'

  ## Dev environment helpers
  # Listen to file modifications and notifies about the changes
  gem 'listen'
  # Keep application running in the background to speed up development
  gem 'spring'
  # RSpec command for Spring
  gem 'spring-commands-rspec'
  # Rubocop command for Spring
  gem 'spring-commands-rubocop'
  # # Makes spring watch files using the listen gem
  gem 'spring-watcher-listen'
  gem 'solargraph'
end
