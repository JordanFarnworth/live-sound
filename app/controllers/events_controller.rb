class EventsController < ApplicationController
  include EntityContext
  include Api::V1::Event

  before_action :load_event, only: [:show, :update, :destroy]
  authorize_resource except: [:index, :show]

  def index
    @events = if @context
      Event.joins(:event_memberships).where(event_memberships: { memberable: @context })
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
      @event.delay.send_notifications!("Event #{@event.title} was updated to #{@event.attributes}")
    else
      render json: @event.errors, status: :bad_request
    end
  end

  def destroy
    @event.destroy
    @event.delay.send_notifications!("Event #{@event.title} was destroyed by #{current_user.name}")
    head :no_content
  end

  def create
    @event = Event.new event_params
    if @event.save
      @event.add_member @context, 'owner'
      Notification.build_notification!(@context, @event, "Event #{@event.title} was created!")
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
