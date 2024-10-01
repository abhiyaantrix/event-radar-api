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
require 'rails_helper'

RSpec.describe Event, type: :model do
  subject(:event) { build(:event) }

  describe '#validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:start_time) }

    context 'when nil end_time (open ended)' do
      let(:open_ended_event) { build(:event, :open_ended) }

      it 'is expected to be valid' do
        expect(open_ended_event).to be_valid
      end
    end

    context 'when end_time is earlier than start_time' do
      xit 'is expected to be invalid' do
      end
    end
  end

  describe '#associations' do
    it { is_expected.to have_many(:event_organizers).inverse_of(:event) }
    it { is_expected.to have_many(:organizers).through(:event_organizers).inverse_of(:organized_events).source(:user) }
    it { is_expected.to have_many(:online_meetings).dependent(:destroy).inverse_of(:event) }
    it { is_expected.to have_many(:offline_meetings).dependent(:destroy).inverse_of(:event) }
  end

  describe 'event types' do
    context 'when both online and offline meetings' do
      xit 'reports hybrid event type' do
      end
    end

    context 'when only online meetings' do
      xit 'reports online event type' do
      end
    end

    context 'when only offline event' do
      xit 'reports offline event type' do
      end
    end
  end
end
