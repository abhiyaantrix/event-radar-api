# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SimpleStateMachine, type: :model do
  subject(:test_model) { SimpleStateMachineTest.create(status: :draft) }

  before(:all) do
    ActiveRecord::Base.connection.create_table(:simple_state_machine_tests, force: true) do |t|
      t.integer :status, default: 0
    end

    class SimpleStateMachineTest < ActiveRecord::Base

      include SimpleStateMachine

      ALLOWED_STATUS_TRANSITIONS = {
        draft: {
          published: {}.freeze,
          archived: {}.freeze
        },
        published: {
          draft: { if: ->(test_model) { test_model.can_revert_to_draft? } },
          cancelled: {}.freeze,
          archived: {}.freeze
        },
        cancelled: {
          archived: {}.freeze
        },
        archived: {}.freeze
      }.freeze

      enum :status, { draft: 0, published: 1, cancelled: 2, archived: 3 }

      validate :ensure_valid_status_transition, on: :update, if: :status_changed?

      def can_revert_to_draft?; true; end

    end
  end

  after(:all) do
    Object.send(:remove_const, :SimpleStateMachineTest)

    ActiveRecord::Base.connection.drop_table(:simple_state_machine_tests, if_exists: true)
  end

  describe 'state transitions' do
    context 'when valid transition' do
      before { test_model.status = :published }

      it { is_expected.to be_valid }
    end

    context 'when invalid transition' do
      before { test_model.status = :cancelled }

      it { is_expected.to be_invalid }
    end
  end

  describe '#allowed_transitions' do
    before { test_model.status = :published }

    it 'provides correct allowed transitions' do
      expect(test_model.allowed_transitions).to match_array([ :draft, :cancelled, :archived ])
    end
  end
end
