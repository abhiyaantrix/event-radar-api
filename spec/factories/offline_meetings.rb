# frozen_string_literal: true

# == Schema Information
#
# Table name: offline_meetings
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
#  index_offline_meetings_on_event_id    (event_id)
#  index_offline_meetings_on_start_time  (start_time)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
FactoryBot.define do
  factory :offline_meeting, traits: [ :future ] do
    title { "offline-meeting-#{Faker::Lorem.sentence(word_count: 3)}" }

    association :event

    # Shared time range traits from 'event_time_range_traits.rb'
    future
    past
    ongoing
    open_ended
  end
end
