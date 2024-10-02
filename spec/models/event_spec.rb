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
require 'rails_helper'

RSpec.describe Event, type: :model do
  subject(:event) { build(:event) }

  describe '#validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:start_time) }

    include_examples 'status validations'
    include_examples 'time range validations'
  end

  describe '.statuses' do
    it 'maps correct status values' do
      expect(Event.statuses).to eq({ 'draft' => 0, 'published' => 1, 'cancelled' => 2, 'archived' => 3 })
    end
  end

  describe '#associations' do
    it { is_expected.to have_many(:event_organizers).inverse_of(:event) }
    it { is_expected.to have_many(:organizers).through(:event_organizers).inverse_of(:organized_events).source(:user) }
    it { is_expected.to have_many(:online_meetings).dependent(:destroy).inverse_of(:event) }
    it { is_expected.to have_many(:offline_meetings).dependent(:destroy).inverse_of(:event) }
  end
end
