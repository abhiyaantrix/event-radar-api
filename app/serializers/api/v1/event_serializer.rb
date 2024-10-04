# frozen_string_literal: true

class API::V1::EventSerializer < BaseSerializer

  include TimestampsFormatter

  attributes :id, :title, :description, :status

  timestamps :created_at, :updated_at, :start_time, :end_time

end
