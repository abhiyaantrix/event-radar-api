# frozen_string_literal: true

class TimeRangeValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, _value)
    start_time = record.start_time
    end_time = record.end_time

    return unless start_time && end_time

    time_invalid = start_time >= end_time

    record.errors.add(attribute, :invalid_time_range) if time_invalid
  end

end
