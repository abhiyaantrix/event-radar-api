# frozen_string_literal: true

# == Schema Information
#
# Table name: event_organizers
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  event_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_event_organizers_on_event_id              (event_id)
#  index_event_organizers_on_event_id_and_user_id  (event_id,user_id) UNIQUE
#  index_event_organizers_on_user_id               (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (user_id => users.id)
#
class EventOrganizer < ApplicationRecord

  belongs_to :event, inverse_of: :event_organizers
  belongs_to :user, inverse_of: :event_organizers

  validates :user, uniqueness: { scope: :event }

  # TODO: Ensure only active users can be assigned to an event
  # TODO: Ensure this rule when updating user in this record and the event is not in past

end
