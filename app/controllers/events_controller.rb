class EventsController < ApplicationController
  include EntityContext
  include Api::V1::Event

  before_action :load_event, only: [:show, :update, :destroy]
  authorize_resource except: [:index]

  def index
    @events = if @context
      Event.joins(:event_members).where(event_members: { id: @context.event_memberships_as_owner_or_performer })
    else
      Event.all
    end

    @events = @events.visible_to_user(current_or_blank_user.id)
    render json: paginated_json(@events) { |events| events_json(events) }
  end

  def show
    render json: event_json(@event)
  end

  def update
    if @event.update event_params
      render json: event_json(@event)
    else
      render json: @event.errors, status: :bad_request
    end
  end

  def destroy
    @event.destroy
    head :no_content
  end

  def create
    @event = Event.new event_params
    if @event.save
      @event.add_member @context, 'owner'
      render json: event_json(@event)
    else
      render json: @event.errors, status: :bad_request
    end
  end

  def load_event
    @event = Event.find params[:id]
  end

  private
  def event_params
    params.require(:event).permit(:start_time, :end_time, :recurrence_pattern, :recurrence_ends_at, :status, :workflow_state, :price, :title, :description, :address, :latitude, :longitude)
  end
end
