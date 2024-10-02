# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts 'Seeding data...'

# running rails db:migrate:reset db:migrate:with_data db:seed together messes up the
# column cache in models. So sometimes db:seed fails with "Unknown attribute: ...".
# This refreshes the column cache.
Rails.application.eager_load!
ApplicationRecord.descendants.each(&:reset_column_information)

## Users
1.times { FactoryBot.create(:user, :archived) }
2.times { FactoryBot.create(:user, :pending) }
3.times { FactoryBot.create(:user) } # active

## Events

FactoryBot.create(:event, :ongoing)
FactoryBot.create(:event, :ongoing, :hybrid_event, :with_organizers)
FactoryBot.create(:event, :ongoing, :with_online_meeting, :with_organizers, organizers_count: 2)
FactoryBot.create(:event, :future, :open_ended, :with_online_meeting)
FactoryBot.create(:event, :future, :hybrid_event, :with_organizers, organizers_count: 3)
FactoryBot.create(:event, :future, :with_offline_meeting, :with_organizers, organizers_count: 3)
FactoryBot.create(:event, :past, :with_offline_meeting, :with_organizers)
FactoryBot.create(:event, :past, :hybrid_event, :with_organizers, organizers_count: 2)

puts 'Seeding data... done'
