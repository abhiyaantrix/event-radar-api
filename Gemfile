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
gem 'active_storage_validations', '~> 1.1.4'

# Annotates Rails/ActiveRecord Models, routes, fixtures, and others based on the database schema
gem 'annotate', '~> 3.2'

# JSON Serialization
gem 'alba', '~> 3.2'
gem 'oj', '~> 3.16.5'

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

group :development, :test do
  # Tests
  gem 'rspec', '~> 3.13'
  gem 'rspec-parameterized', '~> 1.0.2'
  gem 'rspec-rails', '~> 7.0.1'
  # Simple one-liner tests for common Rails functionality
  gem 'shoulda-matchers', '~> 6.4.0'
  # Library for stubbing and setting expectations on HTTP requests
  gem 'webmock', '~> 3.23.1'

  # Test data and mocks
  gem 'factory_bot_rails', '~> 6.4.3'
  # Find unused factories
  gem 'factory_trace', '~> 1.1.1'
  # Generate fake data
  gem 'faker', '~> 3.4.2'
  gem 'timecop'
  gem 'vcr', '~> 6.3.1'

  # Strategies for cleaning databases to ensure clean state for testing suits
  gem 'database_cleaner-active_record'

  # Code coverage
  # gem 'codecov', '~> 0.6', require: false
  gem 'simplecov', '~> 0.22.0', require: false
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
  gem 'rubocop', '~> 1.66.1'
  gem 'rubocop-factory_bot', '~> 2.26.1'
  gem 'rubocop-performance', '~> 1.21.1'
  gem 'rubocop-rails', '~> 2.26.0'
  gem 'rubocop-rake', '~> 0.6.0'
  gem 'rubocop-rspec', '~> 3.0.5'
  gem 'rubocop-rspec_rails', '~> 2.30.0'

  # Code metric tool
  gem 'rails_best_practices', require: false
  # Detects N+1 queries and unused eager loading
  gem 'bullet', '~> 7'
end

group :development do
  # Rails console replacement, renders error with more info: stacktrace, link to SC, REPL
  gem 'better_errors', '2.10.1'
  # Provides REPL for better_errors
  gem 'binding_of_caller'

  ## Dev environment helpers
  # Listen to file modifications and notifies about the changes
  gem 'listen'
  # Keep application running in the background to speed up development
  gem 'spring', '~> 4.2.1'
  # RSpec command for Spring
  gem 'spring-commands-rspec'
  # Rubocop command for Spring
  gem 'spring-commands-rubocop'
  # # Makes spring watch files using the listen gem
  gem 'spring-watcher-listen'
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', require: 'debug/prelude'
  gem 'pry-doc', '~> 1.5'
  gem 'pry-nav', '~> 1.0'
  gem 'pry-rails', '~> 0.3.11'
  gem 'pry-rescue', '~> 1.6'
  gem 'pry-stack_explorer', '~> 0.6.1'
  # gem 'pry-theme', '~> 1.3.1'
  # gem 'pry-inline'
  # gem 'pry-coolline', '~> 0.2.6'
  # gem 'pry-clipboard', '~> 0.1.1'
  # gem 'pry-awesome_print', '~> 9.6.11'
  gem 'solargraph', '~> 0.50.0'
end
