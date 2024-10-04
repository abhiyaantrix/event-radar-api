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
require 'rails_helper'

RSpec.describe OfflineMeeting, type: :model do
  subject(:offline_meeting) { build(:offline_meeting) }

  describe '#validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:start_time) }

    include_examples 'status validations'
    include_examples 'time range validations'
  end

  describe '.statuses' do
    it { is_expected.to define_enum_for(:status).with_values(draft: 0, published: 1, cancelled: 2, archived: 3) }
  end

  describe '#associations' do
    it { is_expected.to belong_to(:event).inverse_of(:offline_meetings) }
  end

  describe 'state machine transitions' do
    using RSpec::Parameterized::TableSyntax

    let(:expected_error_message) do
      lambda do |from, to|
        I18n.t(
          'activerecord.errors.models.offline_meeting.attributes.status.invalid_transition',
          from:,
          to:
        )
      end
    end

    context 'valid transitions' do
      where(:case_name, :from_state, :to_state) do
        [
          [ 'from draft to published',      :draft,     :published ],
          [ 'from draft to archived',       :draft,     :archived ],
          [ 'from published to cancelled',  :published, :cancelled ],
          [ 'from published to archived',   :published, :archived ],
          [ 'from cancelled to archived',   :cancelled, :archived ]
        ]
      end

      with_them do
        let(:offline_meeting) { create(:offline_meeting, status: from_state) }

        before { offline_meeting.status = to_state }

        it { expect(offline_meeting).to be_valid }
      end

      context 'when event is not published yet' do
        let(:event) { create(:event, status: :draft) }
        let(:offline_meeting) { create(:offline_meeting, event:, status: :published) }

        before { offline_meeting.status = :draft }

        it 'allows transition from published to draft' do
          expect(offline_meeting).to be_valid
        end
      end
    end

    context 'invalid transitions' do
      where(:case_name, :from_state, :to_state) do
        [
          [ 'from draft to cancelled',     :draft,     :cancelled ],
          [ 'from cancelled to draft',     :cancelled, :draft ],
          [ 'from cancelled to published', :cancelled, :published ],
          [ 'from archived to draft',      :archived,  :draft ],
          [ 'from archived to published',  :archived,  :published ],
          [ 'from archived to cancelled',  :archived,  :cancelled ]
        ]
      end

      with_them do
        let(:offline_meeting) { create(:offline_meeting, status: from_state) }

        before { offline_meeting.status = to_state }

        it do
          expect(offline_meeting).not_to be_valid
          expect(offline_meeting.errors[:status]).to include(expected_error_message.call(from_state, to_state))
        end
      end

      context 'when event is already published' do
        let(:event) { create(:event, status: :published) }
        let(:offline_meeting) { create(:offline_meeting, event:, status: :published) }

        before { offline_meeting.status = :draft }

        it 'disallows transition from published to draft' do
          expect(offline_meeting).not_to be_valid
          expect(offline_meeting.errors[:status]).to include(expected_error_message.call(:published, :draft))
        end
      end
    end
  end
end
