# frozen_string_literal: true

namespace :db do
  desc 'Check if database exist'
  task exists: :environment do
    Rake::Task['environment'].invoke
    ActiveRecord::Base.connection
  rescue ActiveRecord::NoDatabaseError => e
    puts e.full_message
    exit 1
  else
    exit 0
  end
end
