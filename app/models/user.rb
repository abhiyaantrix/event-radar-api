# frozen_string_literal: true

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
class User < ApplicationRecord

  after_initialize :set_default_preferences, if: :new_record?
  before_save :sanitize_names

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true
  normalizes :email, with: ->(email) { email.downcase }

  serialize :preferences, coder: HashSerializer
  store_accessor :preferences, :theme, prefix: :preference
  validates :preferences, preferences: true

  validates :archival_reason, presence: true, if: :archived?

  enum :status, { pending: 0, active: 1, archived: 2 }

  private

  def set_default_preferences
    self.preference_theme ||= 'system' if self.preferences.blank?
  end

  def sanitize_names
    self.first_name = first_name.strip if first_name_changed?
    self.last_name = last_name.strip if last_name_changed?
  end

end
