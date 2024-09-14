# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

# Inject session middleware into Sidekiq::Web
# TODO: Remove this once proper Authentication is implemented
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_sidekiq_session'

Sidekiq.configure_server do |config|
  Sidekiq.logger.level = Logger::DEBUG
  Rails.logger = Sidekiq.logger
  ActiveRecord::Base.logger = Sidekiq.logger

  config.redis = { url: ENV['SIDEKIQ_REDIS_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['SIDEKIQ_REDIS_URL'] }
end
