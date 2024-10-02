# frozen_string_literal: true

RSpec.shared_examples 'status validations' do
  it { is_expected.to validate_presence_of(:status) }

  it "defaults to 'draft' status" do
    expect(subject.status).to eq('draft')
  end

  it 'is expected to be valid for all defined statuses' do
    subject.class.statuses.keys.each do |valid_status|
      subject.status = valid_status
      expect(subject).to be_valid
    end
  end

  it "is expected to be invalid for 'invalid_status' status value" do
    expect { subject.status = 'invalid_status' }.to raise_error(ArgumentError)
  end

  it "is expected to be invalid for 'nil' value" do
    subject.status = nil
    expect(subject).to be_invalid
  end
end
