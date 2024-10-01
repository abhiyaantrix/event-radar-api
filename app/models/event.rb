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
class Event < ApplicationRecord

  has_many :event_organizers, inverse_of: :event
  has_many :organizers, through: :event_organizers, source: :user, inverse_of: :organized_events

  has_many :online_meetings, dependent: :destroy, inverse_of: :event
  has_many :offline_meetings, dependent: :destroy, inverse_of: :event

  validates :title, :start_time, presence: true
  # TODO: If end_time is present, ensure it is later than start_time
  # TODO: Validate start and end time to be in future and be valid date

  # TODO: Add helper methods to determine online?, offline? or hybrid? events

end
