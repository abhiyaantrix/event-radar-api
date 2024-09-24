# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BaseSerializer do
  subject(:json_serialized) { DummySerializer.new(dummy_record).serialize }

  let(:dummy_record) { Struct.new(:some_attribute).new('some value') }

  let!(:dummy_serializer) do
    class DummySerializer < BaseSerializer

      root_key!
      attributes :some_attribute

    end
  end

  it "transforms key to lowerCame case" do
    expect(json_serialized).to eq("{\"dummy\":{\"someAttribute\":\"some value\"}}")
  end
end
