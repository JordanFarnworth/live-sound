class EventMembersController < ApplicationController
  include Api::V1::EventMember
  include EntityContext

  before_action :find_event_member, only: [:show, :update, :destroy]
  # TODO need to filter some of these actions (update, delete. create) via event_roles (owner, admin)

  def index
    @event_members = EventMember.includes(:event).where(memberable: @context)
    render json: paginated_json(@event_members)
  end

  def show
    respond_to do |format|
      format.json {render json: event_member_json(@event_member, get_includes), status: :ok }
      format.html {@event_member}
    end
  end

  def create
    @event_member = EventMember.new event_member_params
    respond_to do |format|
      if @event_member.valid?
        @event_member.save
        format.json {render json: event_member_json(@event_member, get_includes), status: :ok }
      else
        format.json {render json: {error: "#{@event_member.errors.full_messages}"}, status: :bad_request }
      end
    end
  end

  def update
    @event_member.update event_member_params
    respond_to do |format|
      if @event_member.valid?
        @event_member.save
        format.json {render json: event_member_json(@event_member, get_includes), status: :ok }
      else
        format.json {render json: {error: @event_member.errors.full_messages.to_s}, status: :bad_request }
      end
    end
  end

  def destroy
    @event_member.destroy
    respond_to do |format|
      format.json {render json: {deleted: true}, status: :ok }
    end
  end

  private

  def find_event_member
    @event_member = EventMember.find params[:id] || params[:event_member_id]
  end

  def event_member_params
      params.require(:event_member).permit(:id, :event_id, :member_type, :workflow_state, :memberable_type, :memberable_id, :created_at, :updated_at)
  end

end
