class Event < ApplicationRecord
  has_many :bands, through: :event_members, source: :memberable, source_type: "Band"
  has_many :enterprises, through: :event_members, source: :memberable, source_type: "Enterprise"
  has_many :private_parties, through: :event_members, source: :memberable, source_type: "PrivateParty"
  has_many :users, through: :event_members, source: :memberable, source_type: "User"
  has_many :event_members
  has_many :user_applications, through: :event_applications, source: :applicable, source_type: "User"
  has_many :band_applications, through: :event_applications, source: :applicable, source_type: "Band"
  has_many :notifications, as: :contextable

  scope :active, -> { where(state: 'active') }
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

  def add_member(member, type, status)
    EventMember.find_or_create_by!(memberable: member, member_type: type, status: status, event_id: self.id)
  end

end
