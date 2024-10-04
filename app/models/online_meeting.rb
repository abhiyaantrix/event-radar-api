# frozen_string_literal: true

# == Schema Information
#
# Table name: online_meetings
#
#  id         :bigint           not null, primary key
#  end_time   :datetime
#  start_time :datetime         not null
#  status     :integer          default(0), not null
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

  include SimpleStateMachine

  ALLOWED_STATUS_TRANSITIONS = {
    draft: {
      published: {}.freeze,
      archived: {}.freeze
    },
    published: {
      draft: { if: ->(meeting) { !meeting.event.published? } }.freeze,
      cancelled: {}.freeze,
      archived: {}.freeze
    },
    cancelled: {
      archived: {}.freeze
    },
    archived: {}.freeze
  }.freeze

  # Associations
  belongs_to :event, inverse_of: :online_meetings

  # Enums
  enum :status, { draft: 0, published: 1, cancelled: 2, archived: 3  }

  # Validations
  validates :title, :start_time, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :end_time, allow_nil: true, time_range: true
  validates :start_time, time_range: true

  validate :ensure_valid_status_transition, on: :update, if: :status_changed?

end
