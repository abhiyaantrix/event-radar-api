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
class OnlineMeeting < ApplicationRecord

  # TODO: Add support for setting up online meeting using services like Zoom, Google meet and Microsoft teams

  belongs_to :event, inverse_of: :online_meetings

  validates :title, :start_time, presence: true
  # TODO: If end_time is present, ensure it is later than start_time

end
