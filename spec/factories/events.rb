# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  end_time    :datetime
#  start_time  :datetime         not null
#  status      :integer          default(0), not null
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
    status { :draft }

    # Shared time range traits from 'event_time_range_traits.rb'
    future
    past
    ongoing
    open_ended

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
