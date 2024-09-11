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

      it 'sets full name' do
        expect(user.full_name).to eq("#{user.first_name} #{user.last_name}")
      end

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

    describe '#preferences' do
      it 'sets default preferences when user is created' do
        expect(user.preference_theme).to eq 'system'
      end

      it 'allows setting preferences' do
        user.preference_theme = 'dark'

        expect(user.preference_theme).to eq 'dark'
      end

      context 'invalid theme preference' do
        before do
          user.preference_theme = 'invalid_theme'
          user.valid?
        end

        it 'adds error for invalid theme' do
          is_expected.to be_invalid

          expect(user.errors[:preferences]).to include(
            I18n.t(
              'activerecord.errors.models.user.attributes.preferences.theme.invalid',
              themes: User::THEMES.join(', ')
            )
          )
        end
      end

      context 'invalid preferences structure' do
        before do
          user.preferences = 'invalid_json'
          user.valid?
        end

        it 'adds error for invalid format' do
          is_expected.to be_invalid

          expect(user.errors[:preferences]).to include(
            I18n.t('activerecord.errors.models.user.attributes.preferences.format.invalid')
          )
        end
      end
    end
  end
end
