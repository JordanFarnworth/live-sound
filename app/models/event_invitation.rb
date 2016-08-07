class EventInvitation < ApplicationRecord
  belongs_to :event
  belongs_to :invitable, polymorphic: true

  WORKFLOW_STATES = %w(pending accepted declined)
  INVITATION_TYPES = %w(as_performer as_attendee as_admin)

  validates :event_id, presence: true, uniqueness: { scope: [:invitable_id, :invitable_type, :role] }
  validates :invitable_id, presence: true
  validates :invitable_type, presence: true, inclusion: Entityable::ENTITYABLE_CLASSES
  validates :role, presence: true
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES

  before_validation :infer_values

  def infer_values
    self.workflow_state ||= 'pending'
  end

end
