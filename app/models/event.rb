class Event < ApplicationRecord
  has_many :bands, through: :event_memberships, source: :memberable, source_type: "Band"
  has_many :enterprises, through: :event_memberships, source: :memberable, source_type: "Enterprise"
  has_many :private_parties, through: :event_memberships, source: :memberable, source_type: "PrivateParty"
  has_many :users, through: :event_memberships, source: :memberable, source_type: "User"
  has_many :event_memberships
  has_many :notifications, as: :contextable

  acts_as_paranoid

  scope :active, -> { where(workflow_state: 'active') }
  scope :with_user_as_member, -> (user_id) {
    where <<-SQL
      events.id IN (
        SELECT event_id FROM event_memberships
        INNER JOIN entity_users ON entity_users.userable_type = event_memberships.memberable_type
        AND entity_users.userable_id = event_memberships.memberable_id
        AND entity_users.user_id = #{user_id}
        WHERE event_memberships.deleted_at IS NULL
      )
    SQL
  }
  scope :visible_to_user, -> (user_id) { active.or(with_user_as_member(user_id)) }

  def entities_by_role(role)
    entities = event_memberships.where(role: role).includes(:memberable).map(&:memberable).uniq
  end

  def roles_for_user(user)
    event_memberships_for_user(user).distinct.pluck(:role)
  end

  def all_members
    members = []
    members << bands
    members << enterprises
    members << private_parties
    members << users
    members.flatten.uniq
  end

  def all_applications
    applications = []
    applications << user_applications
    applications << band_applications
    applications.flatten.uniq
  end

  def add_member(member, role, workflow_state = 'active')
    EventMembership.find_or_create_by!(memberable: member, event: self, role: role, workflow_state: workflow_state)
  end

  def invite_member(invitee, role, workflow_state = 'invited')
    # TODO add hook to delete this when a invitee accepts/declines
    EventMembership.find_or_create_by!(memberable: invitee, role: role, event: self, workflow_state: workflow_state)
  end

  def event_memberships_for_user(user)
    event_memberships.joins("INNER JOIN entity_users ON entity_users.userable_type = event_memberships.memberable_type AND entity_users.userable_id = event_memberships.memberable_id")
      .where("entity_users.user_id = ?", user.id)
  end

  def active?
    workflow_state == 'active'
  end
  alias_method :public?, :active?

  def private?
    !public?
  end

  def unpublish!
    self.workflow_state = 'unpublished'
    save!
  end

end
