class Ability
  include CanCan::Ability

  def initialize(user, context = nil)
    user ||= User.new(id: -1)

    can :read, Band, Band.active.or(Band.with_user_as_member(user.id))

    # events
    can :read, Event do |event|
      event.active? || event.event_memberships_for_user(user).exists?
    end

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
  end
end
