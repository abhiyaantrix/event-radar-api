# frozen_string_literal: true

class API::V1::EventsController < API::V1::BaseController

  def index
    # TODO: Pagination, User access limited, apply filtering by status and other attributes
    # Normal users can only view published and cancelled events
    # Organizers can only view their own draft and archived events
    # Only admin can pull events in any statuses
    events = Event.all

    render json: API::V1::EventSerializer.new(events).serialize
  end

end
