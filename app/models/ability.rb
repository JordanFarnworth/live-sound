class Ability
  include CanCan::Ability

  def initialize(user, context = nil)
    user ||= User.new(id: -1)

    can :read, Band, Band.active.or(Band.with_user_as_member(user.id))
    can :read, PrivateParty, PrivateParty.active.or(PrivateParty.with_user_as_member(user.id))
    can :read, Enterprise, Enterprise.active.or(Enterprise.with_user_as_member(user.id))
    can :read, User, id: user.id

    # events
    can :read, Event, Event.visible_to_user(user.id)
    
    can [:update, :destroy], Event do |event|
      event.event_memberships_for_user(user).as_owner.exists?
    end

    can :create, Event if user.persisted? && context.try(:entity_user_for_user, user)

    # reviews
    can :read, Review, workflow_state: 'active'

    can :create, Review if user.persisted?
    can [:update, :destroy], Review do |review|
      review.reviewerable.entity_user_for_user(user)
    end

    # favorites
    can :read, Favorite if user.persisted?
    can :mine, Favorite if user.persisted? && context.try(:entity_user_for_user, user)
    can :create, Favorite if user.persisted?
    can :destroy, Favorite do |favorite|
      favorite.favoriterable.entity_user_for_user(user)
    end

    # event members
    can :read, EventMembership, EventMembership.active
    can :show, EventMembership if user.persisted?
    can :create, EventMembership if user.persisted? && context.is_a?(Event) && Event.visible_to_user(user.id).where(id: context.id).exists?
    can :update, EventMembership
    can :destroy, EventMembership do |membership|
      user_roles = membership.event.event_memberships_for_user(user).distinct.pluck(:role)

      if membership.role == 'owner'
        false
      elsif (%w(owner admin) & user_roles).present?
        true
      else
        membership.memberable.entity_user_for_user(user)
      end
    end
  end
end
