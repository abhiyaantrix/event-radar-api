# frozen_string_literal: true

# == Schema Information
#
# Table name: online_meetings
#
#  id         :bigint           not null, primary key
#  end_time   :datetime
#  start_time :datetime         not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint           not null
#
# Indexes
#
#  index_online_meetings_on_event_id    (event_id)
#  index_online_meetings_on_start_time  (start_time)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
FactoryBot.define do
  factory :online_meeting, traits: [ :future ] do
    title { "online-meeting-#{Faker::Lorem.sentence(word_count: 3)}" }

    association :event

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
  end
end
