class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new(id: -1)

    can :read, Band, Band.active.or(Band.with_user_as_member(user.id))
  end
end
