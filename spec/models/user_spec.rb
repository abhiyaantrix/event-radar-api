# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  archival_reason :text
#  email           :string           not null
#  first_name      :string           not null
#  full_name       :string
#  last_name       :string           not null
#  preferences     :jsonb
#  status          :integer          default("pending"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_on_users_fulltext_search  ((((lower((full_name)::text) || ' '::text) || lower((email)::text))) gin_trgm_ops) USING gin
#  index_users_on_email            (email) UNIQUE
#  index_users_on_email_lower      (lower((email)::text))
#  index_users_on_full_name_lower  (lower((full_name)::text))
#
require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe '#validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    describe 'name sanitization' do
      context 'with leading and trailing spaces' do
        subject(:user) { create(:user, first_name: '  John  ', last_name: 'Doe') }

        it 'strips spaces from names' do
          expect(user.first_name).to eq('John')
          expect(user.full_name).to eq('John Doe')
          expect(user.full_name).to eq('John Doe')
        end
      end
    end

    describe '#full_name' do
      subject(:user) { create(:user) }

      it 'updates when first_name changes' do
        user.update(first_name: 'john')

        expected_full_name = "john #{user.last_name}"

        expect(user.reload.full_name).to eq expected_full_name
      end

      it 'updates when last_name changes' do
        user.update(last_name: 'smith')

        expected_full_name = "#{user.first_name} smith"

        expect(user.reload.full_name).to eq expected_full_name
      end
    end

    describe 'user pending confirmation' do
      subject(:user) { build(:user, :pending) }

      it { is_expected.to be_valid }
    end

    describe 'archived user' do
      context 'with reason' do
        subject(:user) { build(:user, :archived) }

        it { is_expected.to be_valid }
      end

      context 'without reason' do
        subject(:user) { build(:user, :archived, archival_reason: nil) }

        it { is_expected.to be_invalid }
      end
    end
  end
end
