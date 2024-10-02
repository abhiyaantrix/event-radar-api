# frozen_string_literal: true

# == Schema Information
#
# Table name: offline_meetings
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
#  index_offline_meetings_on_event_id    (event_id)
#  index_offline_meetings_on_start_time  (start_time)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#
class OfflineMeeting < ApplicationRecord

  # TODO: Add support for physical address, it should be validated with maps API

  # Associations
  belongs_to :event, inverse_of: :offline_meetings

  # Enums
  enum status: { draft: 0, published: 1, cancelled: 2, archived: 3  }

  # Validations
  validates :title, :start_time, presence: true
  validates :end_time, allow_nil: true, time_range: true
  validates :start_time, time_range: true

end
