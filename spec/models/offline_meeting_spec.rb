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
require 'rails_helper'

RSpec.describe OfflineMeeting, type: :model do
  subject(:offline_meeting) { build(:offline_meeting) }

  describe '#validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:start_time) }

    context 'when nil end_time (open ended)' do
      let(:open_ended_meeting) { build(:offline_meeting, :open_ended) }

      it 'is expected to be valid' do
        expect(open_ended_meeting).to be_valid
      end
    end

    context 'when end_time is earlier than start_time' do
      xit 'is expected to be invalid' do
      end
    end
  end

  describe '#associations' do
    it { is_expected.to belong_to(:event).inverse_of(:offline_meetings) }
  end
end
