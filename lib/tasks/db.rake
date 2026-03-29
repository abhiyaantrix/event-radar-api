# frozen_string_literal: true

# pg_dump 16+ (Ubuntu packaging) emits a random session token and a version
# header that vary between runs and environments. Strip them so that
# db/structure.sql stays stable and the db_reset spec comparison passes.
Rake::Task["db:structure:dump"].enhance do
  structure_file = ActiveRecord::Tasks::DatabaseTasks.schema_dump_path(
    ActiveRecord::Base.configurations.find_db_config(Rails.env)
  )

  next unless File.exist?(structure_file)

  content = File.read(structure_file)

  # Remove \restrict / \unrestrict psql meta-commands (random token per dump)
  content.gsub!(/^\\(un)?restrict \S+\n/, "")
  # Remove "-- Dumped from/by database version X.Y" header comments
  content.gsub!(/^-- Dumped (from database version|by pg_dump version) .*\n/, "")
  # Collapse any leading blank lines left behind
  content.sub!(/\A(\n)+/, "")

  File.write(structure_file, content)
end

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
