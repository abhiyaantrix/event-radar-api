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
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:start_time) }

    include_examples 'status validations'
    include_examples 'time range validations'
  end

  describe '.statuses' do
    it { is_expected.to define_enum_for(:status).with_values(draft: 0, published: 1, cancelled: 2, archived: 3) }
  end

  describe '#associations' do
    it { is_expected.to have_many(:event_organizers).inverse_of(:event) }
    it { is_expected.to have_many(:organizers).through(:event_organizers).source(:user).inverse_of(:organized_events) }
    it { is_expected.to have_many(:online_meetings).dependent(:destroy).inverse_of(:event) }
    it { is_expected.to have_many(:offline_meetings).dependent(:destroy).inverse_of(:event) }
  end

  describe '#has_published_meetings?' do
    let(:event) { create(:event) }

    where(:case_name, :online_meeting_status, :offline_meeting_status, :expected_result) do
      [
        [ 'when published online meeting',                    :published,   nil,        true ],
        [ 'when published offline meeting',                   nil,          :published, true ],
        [ 'when both published online and offline meetings',  :published,   :published, true ],
        [ 'when no meetings',                                 nil,          nil,        false ],
        [ 'when all unpublished meetings',                    :draft,       :draft,     false ],
        [ 'when only one published meeting',                  :published,   :draft,     true ]
      ]
    end

    with_them do
      before do
        create(:online_meeting, event:, status: online_meeting_status) if online_meeting_status
        create(:offline_meeting, event:, status: offline_meeting_status) if offline_meeting_status
      end

      it { expect(event.has_published_meetings?).to eq(expected_result) }
    end
  end

  describe 'state machine transitions' do
    using RSpec::Parameterized::TableSyntax

    let(:expected_error_message) do
      lambda do |from, to|
        I18n.t(
          'activerecord.errors.models.event.attributes.status.invalid_transition',
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
        let(:event) { create(:event, status: from_state) }

        before { event.status = to_state }

        it { expect(event).to be_valid }
      end

      context 'when there are no published meetings' do
        let(:event) { create(:event, status: :published) }

        before do
          allow(event).to receive(:has_published_meetings?).and_return(false)

          event.status = :draft
        end

        it 'allows transition from published to draft' do
          expect(event).to be_valid
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
        let(:event) { create(:event, status: from_state) }

        before { event.status = to_state }

        it do
          expect(event).not_to be_valid
          expect(event.errors[:status]).to include(expected_error_message.call(from_state, to_state))
        end
      end

      context 'when there are published meetings' do
        let(:event) { create(:event, status: :published) }

        before do
          allow(event).to receive(:has_published_meetings?).and_return(true)

          event.status = :draft
        end

        it 'disallows transition from published to draft' do
          expect(event).not_to be_valid
          expect(event.errors[:status]).to include(expected_error_message.call(:published, :draft))
        end
      end
    end
  end
end
