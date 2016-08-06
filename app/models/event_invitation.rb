class EventInvitation < ApplicationRecord
  belongs_to :event
  belongs_to :invitable, polymorphic: true

  WORKFLOW_STATES = %w(pending accepted declined)
  INVITATION_TYPES = %w(as_performer as_guest)
  INVITABLE_TYPES = %w(Band Enterprise PrivateParty User)

  validates :event_id, presence: true
  validates :invitable_id, presence: true
  validates :invitable_type, presence: true, inclusion: INVITABLE_TYPES
  validates :invitation_type, presence: true, inclusion: INVITATION_TYPES
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES

end
