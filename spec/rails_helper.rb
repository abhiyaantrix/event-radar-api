# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

VCR_CONSISTENCY_CHECK = ActiveModel::Type::Boolean.new.cast(ENV.fetch('VCR_CONSISTENCY_CHECK', nil))

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'spec_helper'
require 'simplecov_helper'
require 'rspec/rails'
require 'sidekiq/testing'
require 'factory_bot_rails'
require 'shoulda-matchers'
require 'webmock/rspec'
require 'socket'
require 'net/http'
require 'active_support/testing/time_helpers'
require 'database_cleaner/active_record'
require 'active_storage_validations/matchers'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.default_cassette_options = { match_requests_on: %i[method path body] }
  config.filter_sensitive_data('<USER_PASSWORD>') do |interaction|
    auths = interaction.request.headers['Authorization']&.first
    # Basic:
    # Bearer:
    if auths && (match = auths.match(/^(\S*)$|(Basic|Bearer)\s+([^,\s]+)/))
      match.captures.last
    elsif interaction.request.body.include?('"key"')
      interaction.request.body[/"key":"(\w+)"/, 1] # filter key param in the request body
    end
  end
end

Sidekiq::Testing.fake!

Rack::Attack.enabled = false

WebMock.disable_net_connect!(
  allow: %w[0.0.0.0],
  allow_localhost: true
)

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

# Track used VCR cassettes
Thread.current[:used_cassettes] = Set.new
module CassetteReporter

  def insert_cassette(name, options = {})
    Thread.current[:used_cassettes] << VCR::Cassette.new(name, options).file if VCR_CONSISTENCY_CHECK
    super
  end

end
VCR.extend(CassetteReporter)

RSpec.configure do |config|
  config.example_status_persistence_file_path = Rails.root.join('spec', 'examples.txt')
  config.use_transactional_fixtures = false
  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  config.order = :random
  config.color = true
  config.tty = true
  config.formatter = :documentation
  config.file_fixture_path = 'spec/fixtures'

  config.infer_spec_type_from_file_location!

  # Include helpers
  config.include(FactoryBot::Syntax::Methods)
  config.include(ActiveStorageValidations::Matchers)
  config.include(ActiveSupport::Testing::TimeHelpers)
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)
  config.include(JsonHelper)
  config.include(ActiveStorageBlobHelper)

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each, type: :request) do
    host! 'localhost:3000'
  end

  config.before do
    Sidekiq::Worker.clear_all

    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    ActiveJob::Base.queue_adapter.enqueued_jobs.clear
  end

  config.before(:each, type: :system) do
    driven_by(:rack_test)
  end

  config.before(:suite) do
    DatabaseCleaner.allow_production = false
    DatabaseCleaner.allow_remote_database_url = true

    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around do |example|
    DatabaseCleaner.cleaning { example.run }
  end

  config.append_after do
    DatabaseCleaner.clean
  end

  config.after(:suite) do
    FileUtils.rm_rf(Rails.root.join('tmp', 'storage'))

    if VCR_CONSISTENCY_CHECK
      used_cassettes = Thread.current[:used_cassettes]
      all_cassettes = Dir[File.join(VCR.configuration.cassette_library_dir, '**/*.yml')]
                      .to_set { |d| File.expand_path(d) }

      cassettes = all_cassettes - used_cassettes
      if cassettes.any?
        error = <<-MSG
        Unused VCR cassettes detected, please review and delete them if they are not needed:

        #{cassettes.map { |f| f.sub(Rails.root.join.to_s, '') }.join("\n")}
        MSG

        raise error
      end
    end
  end

  if Bullet.enable?
    config.before(:each) do
      Bullet.start_request
    end

    config.after(:each) do
      Bullet.perform_out_of_channel_notifications if Bullet.notification?
      Bullet.end_request
    end
  end
end

# Custom RSpec negated matchers
RSpec::Matchers.define_negated_matcher :not_change, :change

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
