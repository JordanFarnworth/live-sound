class Event < ApplicationRecord
  has_many :bands, through: :event_members, source: :memberable, source_type: "Band"
  has_many :enterprises, through: :event_members, source: :memberable, source_type: "Enterprise"
  has_many :private_parties, through: :event_members, source: :memberable, source_type: "PrivateParty"
  has_many :users, through: :event_members, source: :memberable, source_type: "User"
  has_many :event_members
  has_many :event_invitations
  has_many :notifications, as: :contextable

  scope :active, -> { where(workflow_state: 'active') }
  scope :with_user_as_member, -> (user_id) {
    where <<-SQL
      events.id IN (
        SELECT event_id FROM event_members
        INNER JOIN entity_users ON entity_users.userable_type = event_members.memberable_type
        AND entity_users.userable_id = event_members.memberable_id
        AND entity_users.user_id = #{user_id}
      )
    SQL
  }
  scope :visible_to_user, -> (user_id) { active.or(with_user_as_member(user_id)) }

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

  def add_member(member, type, workflow_state="active")
    EventMember.find_or_create_by!(memberable: member, member_type: type, event: self, workflow_state: workflow_state)
  end

  def add_members(*members)
    raise "need all args: member|member_type|workflow_state(workflow_state optional)" unless member[0].present? && member[1].present?
    # members must be passed as: [member, member_type, workflow_state]
    members.each { |member| add_member(member[0], member[1], member.try(:[], 2))}
  end

  def invite_member(invitee, type, workflow_state="pending")
    # TODO add hook to delete this when a invitee accepts/declines
    EventInvitation.find_or_create_by!(invitable: invitee, invitation_type: type, event: self, workflow_state: workflow_state)
  end

end
