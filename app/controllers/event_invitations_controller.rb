class EventInvitationsController < ApplicationController
  include Api::V1::EventInvitation
  include EntityContext

  before_action :find_event_invitation, only: [:show, :update, :destroy]
  # TODO need to filter some of these actions (update, delete. create) via event_roles (owner, admin)

  def index
    @event_invitations = EventInvitation.includes(:event).where(invitable: @context)
    render json: paginated_json(@event_invitations)
  end

  def show
    respond_to do |format|
      format.json {render json: event_invitation_json(@event_invitation, get_includes), status: :ok }
      format.html {@event_invitation}
    end
  end

  def create
    @event_invitation = EventInvitation.new event_invitation_params
    respond_to do |format|
      if @event_invitation.valid?
        @event_invitation.save
        format.json {render json: event_invitation_json(@event_invitation, get_includes), status: :ok }
      else
        format.json {render json: {error: "#{@event_invitation.errors.full_messages}"}, status: :bad_request }
      end
    end
  end

  def update
    @event_invitation.update event_invitation_params
    respond_to do |format|
      if @event_invitation.valid?
        @event_invitation.save
        format.json {render json: event_invitation_json(@event_invitation, get_includes), status: :ok }
      else
        format.json {render json: {error: @event_invitation.errors.full_messages.to_s}, status: :bad_request }
      end
    end
  end

  def destroy
    @event_invitation.destroy
    respond_to do |format|
      format.json {render json: {deleted: true}, status: :ok }
    end
  end

  private

  def find_event_invitation
    @event_invitation = EventInvitation.find params[:id] || params[:event_invitation_id]
  end

  def event_invitation_params
    params.require(:event_invitation).permit(:id, :event_id, :workflow_state, :invitable_type, :invitable_id, :invitation_type,  :created_at, :updated_at)
  end

end
