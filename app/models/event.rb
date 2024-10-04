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
class Event < ApplicationRecord

  include SimpleStateMachine

  ALLOWED_STATUS_TRANSITIONS = {
    draft: {
      published: {}.freeze,
      archived: {}.freeze
    },
    published: {
      draft: { if: ->(event) { !event.has_published_meetings? } }.freeze,
      cancelled: {}.freeze,
      archived: {}.freeze
    },
    cancelled: {
      archived: {}.freeze
    },
    archived: {}.freeze
  }.freeze

  # Associations
  has_many :event_organizers, inverse_of: :event
  has_many :organizers, through: :event_organizers, source: :user, inverse_of: :organized_events

  has_many :online_meetings, dependent: :destroy, inverse_of: :event
  has_many :offline_meetings, dependent: :destroy, inverse_of: :event

  # Enums
  enum :status, { draft: 0, published: 1, cancelled: 2, archived: 3  }

  # Validations
  validates :title, :start_time, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :end_time, allow_nil: true, time_range: true
  validates :start_time, time_range: true

  validate :ensure_valid_status_transition, on: :update, if: :status_changed?

  # TODO: Add helper methods to determine online?, offline? or hybrid? events

  def has_published_meetings?
    online_meetings.published.exists? || offline_meetings.published.exists?
  end

end
