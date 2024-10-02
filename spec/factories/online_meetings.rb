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

    # Shared time range traits from 'event_time_range_traits.rb'
    future
    past
    ongoing
    open_ended
  end
end
