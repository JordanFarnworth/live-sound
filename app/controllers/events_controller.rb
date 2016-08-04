class EventsController < ApplicationController
  include EntityContext

  def index
    @events = if @context
      Event.joins(:event_members).where(event_members: { id: @context.event_memberships_as_owner_or_performer })
    else
      Event.all
    end

    @events = @events.visible_to_user(current_or_blank_user.id)
    render json: paginated_json(@events)
  end
end
