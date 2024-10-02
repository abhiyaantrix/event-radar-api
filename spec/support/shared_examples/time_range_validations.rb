# frozen_string_literal: true

# spec/support/shared_examples/time_range_validations.rb

RSpec.shared_examples 'time_range_validations' do
  let(:model_name) { described_class.to_s.underscore }

  describe 'time range validations' do
    context 'when nil end_time (open ended)' do
      let(:open_ended_meeting) { build(model_name.to_sym, :open_ended) }

      it 'is expected to be valid' do
        expect(open_ended_meeting).to be_valid
      end
    end

    context 'when start_time is earlier than end_time' do
      let(:valid_meeting) { build(model_name.to_sym, start_time: Time.current, end_time: 1.hour.from_now) }

      it 'is expected to be valid' do
        expect(valid_meeting).to be_valid
      end
    end

    context 'when end_time is earlier than start_time' do
      let(:invalid_meeting) { build(model_name.to_sym, start_time: Time.current, end_time: 1.hour.ago) }

      it 'is expected to be invalid' do
        expect(invalid_meeting).not_to be_valid
        expect(invalid_meeting.errors[:start_time])
          .to include(I18n.t("activerecord.errors.models.#{model_name}.attributes.start_time.invalid_time_range"))
        expect(invalid_meeting.errors[:end_time])
          .to include(I18n.t("activerecord.errors.models.#{model_name}.attributes.end_time.invalid_time_range"))
      end
    end

    context 'when start_time and end_time are equal' do
      let(:current_time) { Time.current }
      let(:equal_time_meeting) { build(model_name.to_sym, start_time: current_time, end_time: current_time) }

      it 'is expected to be invalid' do
        expect(equal_time_meeting).not_to be_valid
        expect(equal_time_meeting.errors[:start_time])
          .to include(I18n.t("activerecord.errors.models.#{model_name}.attributes.start_time.invalid_time_range"))
        expect(equal_time_meeting.errors[:end_time])
          .to include(I18n.t("activerecord.errors.models.#{model_name}.attributes.end_time.invalid_time_range"))
      end
    end
  end
end
