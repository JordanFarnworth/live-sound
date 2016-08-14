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
    membership_roles = @event.event_memberships_for_user(current_user).distinct.pluck(:role)

    return raise CanCan::AccessDenied if @event.private? && (%w(owner admin) & membership_roles).empty?
    entity = instantiated_object create_event_membership_params[:memberable_type], create_event_membership_params[:memberable_id]

    if entity.entity_user_for_user(current_user)
      # Why would an entity want to invite themselves to an event, but keep their membership state as just invited? :shifty-eyes:
      params[:event_membership][:workflow_state] = 'active'
    else
      # unless the current user is a member of the entity for which they're creating a membership,
      # the membership can only be created as invited
      params[:event_membership][:workflow_state] = 'invited'
    end

    # unless the current user is an owner or admin of the event, they can only invite
    # other entities with a role of attendee
    params[:event_membership][:role] = 'attendee' if (%w(owner admin) & membership_roles).empty?

    # only 1 owner can be set for an event, which is done during event creation
    params[:event_membership][:role] = 'admin' if create_event_membership_params[:role] == 'owner'

    @event_membership = @event.event_memberships.new create_event_membership_params
    @event_membership.memberable = entity
    if @event_membership.save
      render json: event_membership_json(@event_membership, get_includes), status: :ok
      if @event_membership.status == 'pending' && @event_membership.workflow_state == 'invitation'
        Notification.build_notification!(@event_membership.memberable, @event_membership.event, "You have been invited to #{@event_membership.event.title}, as (an) #{@event_membership.role}")
        @event.delay.send_notifications!("#{@event_membership.memberable.name} was invited to #{@event.title} as a(n) #{@event_membership.role}", @event.event_memberships.select {|membership| membership != @event_membership})
      elsif @event_membership.status == 'accepted' && @event_membership.workflow_state == 'active_member'
        Notification.build_notification!(@event_membership.memberable, @event_membership.event, "You have been added to #{@event_membership.event.title}, as (an) #{@event_membership.role}")
        @event.delay.send_notifications!("#{@event_membership.memberable.name} was added to #{@event.title} as a(n) #{@event_membership.role}", @event.event_memberships.select {|membership| membership != @event_membership})
      end
    else
      render json: @event_membership.errors, status: :bad_request
    end
  end

  def update
    membership_roles = @event.event_memberships_for_user(current_user).distinct.pluck(:role)

    if params[:event_membership][:workflow_state] == 'active' && @event_membership.invited? &&
        !@event_membership.memberable.entity_user_for_user(current_user)

      # don't allow invitations to be accepted if the current user is not a member of the entity to which the membership belongs
      params[:event_membership].delete :workflow_state
    end

    if (%w(owner admin) & membership_roles).empty? || params[:event_membership][:role] == 'owner'
      params[:event_membership].delete :role
    end

    if params[:event_membership].blank? || @event_membership.update(update_event_membership_params)
      render json: event_membership_json(@event_membership, get_includes), status: :ok
      Notification.build_notification!(@event_membership.memberable, @event_membership.event, "Your membership in event #{@event_membership.event.title} has been updated as status: #{@event_membership.event.status}, role: #{@event_membership.role}")
    else
      render json: @event_membership.errors, status: :bad_request
    end
  end

  def destroy
    @event_membership.destroy
    Notification.build_notification!(@event_membership.memberable, @event_membership.event, "Your membership in event #{@event_membership.event.title} has been destroyed")
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
