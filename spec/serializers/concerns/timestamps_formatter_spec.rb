# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimestampsFormatter do
  subject(:parsed_record) { JSON.parse(DummySerializer.new(dummy_record).serialize).symbolize_keys }

  before do
    Object.const_set(
      :DummySerializer,
      Class.new do
        include Alba::Resource
        include TimestampsFormatter

        timestamps :created_at, :updated_at
      end
    )
  end

  after { Object.send(:remove_const, :DummySerializer) }

  context 'when valid timestamps' do
    let(:dummy_record) { Struct.new(:created_at, :updated_at).new(Time.now, Time.now) }

    it 'formats created_at in ISO 8601 format' do
      expect(parsed_record[:created_at]).to eq(dummy_record.created_at.iso8601)
    end

    it 'formats updated_at in ISO 8601 format' do
      expect(parsed_record[:updated_at]).to eq(dummy_record.updated_at.iso8601)
    end
  end

  context 'when invalid timestamps' do
    let(:dummy_record) { Struct.new(:created_at, :updated_at).new(nil, Time.now) }

    it 'handles nil timestamp' do
      expect(parsed_record[:created_at]).to be_nil
      expect(parsed_record[:updated_at]).to eq(dummy_record.updated_at.iso8601)
    end
  end
end
