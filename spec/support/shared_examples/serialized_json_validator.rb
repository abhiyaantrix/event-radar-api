# frozen_string_literal: true

RSpec.shared_examples 'validate serialized json' do
  it 'includes expected attributes' do
    expect(JSON.parse(serialized_json)).to eq(expected_data)
  end
end
