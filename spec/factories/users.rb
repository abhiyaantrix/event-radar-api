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
FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    status { :active }
    preferences { { theme: 'system' } }

    trait :pending do
      status { :pending }
    end

    trait :archived do
      status { :archived }
      archival_reason { Faker::Lorem.sentence(word_count: 3) }
    end
  end
end
