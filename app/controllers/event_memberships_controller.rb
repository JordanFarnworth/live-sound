class EventMembershipsController < ApplicationController
  include Api::V1::EventMembership
  include EntityContext
  include EventContext

  before_action :find_event_membership, only: [:show, :update, :destroy]
  authorize_resource except: [:index]

  def index
    @event_memberships = @context.event_memberships
    render json: paginated_json(@event_memberships) { |event_memberships| event_memberships_json(event_memberships) }
  end

  def create
    @event_membership = @event.event_memberships.new create_event_membership_params
    @event_membership.event = @event
    if @event_membership.save
      render json: event_membership_json(@event_membership, get_includes), status: :ok
    else
      render json: @event_membership.errors, status: :bad_request
    end
  end

  def update
    if @event_membership.update update_event_membership_params
      render json: event_membership_json(@event_membership, get_includes), status: :ok
    else
      render json: @event_membership.errors, status: :bad_request
    end
  end

  def destroy
    @event_membership.destroy
    head :no_content
  end

  private

  def find_event_membership
    @event_membership = EventMembership.find params[:event_membership_id] || params[:id]
  end

  def create_event_membership_params
    params.require(:event_membership).permit(:role, :workflow_state, :memberable_type, :memberable_id, :event_id)
  end

  def update_event_membership_params
    params.require(:event_membership).permit(:role, :workflow_state)
  end

end
