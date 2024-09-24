# frozen_string_literal: true

# Adds method to serialize timestamp attributes like created_at, updated_at into ISO 8601 format
module TimestampsFormatter

  extend ActiveSupport::Concern

  class_methods do
    # Usage:
    # timestamps :created_at
    # timestamps :created_at, :updated_at
    # timestamps :created_at, :updated_at, :deleted_at
    def timestamps(*attrs)
      attrs.each { |attr| add_timestamp_attribute(attr) }
    end

    private

    def add_timestamp_attribute(attr)
      attribute(attr) { |object| object.public_send(attr)&.iso8601 }
    end
  end

end
