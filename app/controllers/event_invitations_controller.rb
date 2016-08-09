class EventInvitationsController < ApplicationController
  load_and_authorize_resource
  include Api::V1::EventInvitation
  include EntityContext
  include EventContext

  before_action :find_event_invitation, only: [:show, :update, :destroy]
  before_action :find_event, only: [:index, :create]
  # TODO need to filter some of these actions (update, delete. create) via event_roles (owner, admin)

  def index
    @event = Event.find params[:event_id] || event_invitation_params[:event_id]
    @event_invitations ||= EventInvitation.includes(:event).where(event: @event) unless @event.blank?
    @event_invitations ||= EventInvitation.all
    render json: paginated_json(@event_invitations) { |event_invitations| event_invitations_json(event_invitations) }
  end

  def show
    render json: event_invitation_json(@event_invitation, get_includes), status: :ok
  end

  def create
    @event_invitation = EventInvitation.new event_invitation_params
    @event_invitation.event ||= @event
    if @event_invitation.save
      render json: event_invitation_json(@event_invitation, get_includes), status: :ok
    else
      render json: {error: "#{@event_invitation.errors.full_messages}"}, status: :bad_request
    end
  end

  def update
    if @event_invitation.update event_invitation_params
      render json: event_invitation_json(@event_invitation, get_includes), status: :ok
    else
      render json: {error: @event_invitation.errors.full_messages.to_s}, status: :bad_request
    end
  end

  def destroy
    @event_invitation.destroy
    head :no_content
  end

  private

  def find_event
    @event = Event.find params[:event_id] || event_invitation_params[:event_id]
  end

  def find_event_invitation
    @event_invitation = EventInvitation.find params[:id] || params[:event_invitation_id]
  end

  def event_invitation_params
    params.require(:event_invitation).permit(:id, :event_id, :workflow_state, :invitable_type, :invitable_id, :role,  :created_at, :updated_at)
  end

end
