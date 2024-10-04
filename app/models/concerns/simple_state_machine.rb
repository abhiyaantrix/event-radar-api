# frozen_string_literal: true

module SimpleStateMachine

  extend ActiveSupport::Concern

  # Requires a constant ALLOWED_STATUS_TRANSITIONS to be defined
  # Format:
  #   - FROM -> TO
  #   - {} - allowed
  #   - if: -> {} - rule depends on the object state
  #   - not present - not allowed
  #
  # Example:
  #   ALLOWED_STATUS_TRANSITIONS = {
  #     draft: {
  #       published: {}.freeze,
  #       archived: {}.freeze
  #     },
  #     published: {
  #       draft: { if: ->(event) { event.meetings.none? } }.freeze,
  #       cancelled: {}.freeze,
  #       archived: {}.freeze
  #     },
  #     cancelled: {
  #       archived: {}.freeze
  #     },
  #     archived: {}.freeze
  #   }.freeze
  included do
    # Validates if the transition from the old status to the new status is allowed
    # It checks against the ALLOWED_STATUS_TRANSITIONS constant defined in the model
    # If the transition is not allowed, it adds an error to the model
    # This method is called automatically before saving the model if the status has changed
    #
    # Example usage:
    #   user = Event.find(1)
    #   user.status = :archived
    #   user.save
    #   # This might trigger the validation and add an error to the event's errors if this transition is not allowed
    def ensure_valid_status_transition
      current_status = status.to_sym
      old_status = status_was.to_sym

      rule = self.class::ALLOWED_STATUS_TRANSITIONS.dig(old_status, current_status)

      return if rule && rule[:if]&.call(self) != false

      errors.add(:status, :invalid_transition, from: old_status, to: current_status)
    end

    # Returns an array of allowed status transitions from the current status
    # It takes into account the rules defined in the `ALLOWED_STATUS_TRANSITIONS` constant
    # Status is assumed to be valid
    #
    # Example usage:
    #   event = Event.find(1)
    #   allowed_transitions = event.allowed_transitions
    #   # This might return [:published, :cancelled, :archived] as allowed transitions
    def allowed_transitions
      @allowed_transitions ||= begin
        current_status = status.to_sym
        transitions = self.class::ALLOWED_STATUS_TRANSITIONS[current_status] || {}

        transitions.select { |_, rule| rule[:if]&.call(self) != false }.keys
      end
    end
  end

end
