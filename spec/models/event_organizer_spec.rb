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
#  index_event_organizers_on_user_id               (user_id)
#  index_event_organizers_on_user_id_and_event_id  (user_id,event_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (event_id => events.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe EventOrganizer, type: :model do
  subject(:event_organizer) { build(:event_organizer) }

  describe '#validations' do
    let(:existing_organizer) { create(:event_organizer) }
    let(:duplicate_organizer) do
      build(:event_organizer, event: existing_organizer.event, user: existing_organizer.user)
    end

    it 'validates uniqueness of user in event scope' do
      expect(duplicate_organizer).to be_invalid
      expect(duplicate_organizer.errors[:user])
        .to include(I18n.t('activerecord.errors.models.event_organizer.attributes.user.taken'))
    end
  end

  describe '#associations' do
    it { is_expected.to belong_to(:event).inverse_of(:event_organizers) }
    it { is_expected.to belong_to(:user).inverse_of(:event_organizers) }
  end
end
