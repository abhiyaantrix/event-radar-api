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
require 'rails_helper'

RSpec.describe OnlineMeeting, type: :model do
  subject(:online_meeting) { build(:online_meeting) }

  describe '#validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:start_time) }

    it "defaults to 'draft' status" do
      expect(online_meeting.status).to eq('draft')
    end

    include_examples 'time_range_validations'
  end

  describe '.statuses' do
    it "maps correct status values" do
      expect(OnlineMeeting.statuses).to eq({ 'draft' => 0, 'published' => 1, 'cancelled' => 2, 'archived' => 3 })
    end
  end

  describe '#associations' do
    it { is_expected.to belong_to(:event).inverse_of(:online_meetings) }
  end
end
