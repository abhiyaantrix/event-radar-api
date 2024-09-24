# frozen_string_literal: true

class API::V1::UserSerializer < BaseSerializer

  include TimestampsFormatter

  attributes :id, :email, :first_name, :last_name, :full_name, :status

  attributes :archival_reason, if: ->(user) { user.archived? }

  attribute :preferences do |user|
    user.preferences.with_indifferent_access
  end

  timestamps :created_at, :updated_at

end
