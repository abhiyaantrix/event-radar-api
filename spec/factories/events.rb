# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  end_time    :datetime
#  start_time  :datetime         not null
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_events_on_start_time  (start_time)
#
FactoryBot.define do
  factory :event, traits: [ :future ] do
    title { "event-#{Faker::Lorem.sentence(word_count: 3)}" }
    description { Faker::Lorem.paragraph }

    start_time { Faker::Time.between(from: DateTime.now + 1.day, to: DateTime.now + 5.days, format: :default) }

    trait :future do
      end_time { Faker::Time.between(from: DateTime.now + 5.days, to: DateTime.now + 10.days, format: :default) }
    end

    trait :past do
      start_time { Faker::Time.between(from: DateTime.now - 10.days, to: DateTime.now - 5.days, format: :default) }
      end_time { Faker::Time.between(from: DateTime.now - 5.days, to: DateTime.now - 1.day, format: :default) }
    end

    trait :ongoing do
      start_time { Faker::Time.between(from: DateTime.now - 1.day, to: DateTime.now, format: :default) }
      end_time { Faker::Time.between(from: DateTime.now + 1.hour, to: DateTime.now + 2.days, format: :default) }
    end

    trait :open_ended do
      end_time { nil }
    end

    trait :with_online_meeting do
      after(:create) do |event|
        create(:online_meeting, event:)
      end
    end

    trait :with_offline_meeting do
      after(:create) do |event|
        create(:offline_meeting, event:)
      end
    end

    trait :hybrid_event do
      after(:create) do |event|
        create(:online_meeting, event:)
        create(:offline_meeting, event:)
      end
    end

    # FactoryBot.create(:event, :with_organizers, organizers_count: 3)
    transient { organizers_count { 1 } }
    trait :with_organizers do
      after(:create) do |event, evaluator|
        create_list(:event_organizer, evaluator.organizers_count, event:)
      end
    end
  end
end
