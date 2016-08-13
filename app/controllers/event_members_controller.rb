class EventMembersController < ApplicationController
  include Api::V1::EventMember
  include EntityContext

  before_action :find_event_member, only: [:show, :update, :destroy]
  # TODO need to filter some of these actions (update, delete. create) via event_roles (owner, admin)

  def index
    @event = Event.find params[:event_id] || event_member_params[:event_id]
    @event_members ||= EventMember.includes(:event).where(event: @event) unless @event.blank?
    @event_members ||= EventMember.all
    render json: paginated_json(@event_members) { |event_members| event_members_json(event_members) }
  end

  def show
    render json: event_member_json(@event_member, get_includes), status: :ok
  end

  def create
    @event = Event.find params[:event_id] || event_member_params[:event_id]
    unless @event.blank?
      if can?(:create_event_member, @event)
        @event_member = EventMember.new event_member_params
        @event_member.event_id = @event.id
      end
    end
    @event_member ||= EventMember.new event_member_params
    if @event_member.save
      render json: event_member_json(@event_member, get_includes), status: :ok
    else
      render json: {error: "#{@event_member.errors.full_messages}"}, status: :bad_request
    end
  end

  def update
    if @event_member.update event_member_params
      render json: event_member_json(@event_member, get_includes), status: :ok
    else
      render json: {error: @event_member.errors.full_messages.to_s}, status: :bad_request
    end
  end

  def destroy
    @event_member.destroy
    head :no_content
  end

  private

  def find_event_member
    @event_member = EventMember.find params[:id] || params[:event_member_id]
  end

  def event_member_params
      params.require(:event_member).permit(:id, :event_id, :role, :workflow_state, :memberable_type, :memberable_id, :created_at, :updated_at)
  end

end
