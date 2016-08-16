class EventMembership < ApplicationRecord
  belongs_to :event
  belongs_to :memberable, polymorphic: true

  WORKFLOW_STATES = %w(invited active pending declined)
  EVENT_ROLES = %w(owner admin performer attendee)

  acts_as_paranoid

  scope :as_owner, -> { where(role: 'owner') }
  scope :as_owner_or_admin, -> { where(role: %w(owner admin)) }
  scope :as_owner_or_performer, -> { where(role: %w(owner performer)) }
  scope :active, -> { where(workflow_state: 'active') }
  scope :invited, -> { where(workflow_state: 'invited') }
  scope :pending, -> { where(workflow_state: 'pending') }
  scope :declined, -> { where(workflow_state: 'declined') }

  validates :event_id, presence: true, uniqueness: { scope: [:memberable_id, :memberable_type, :role] }
  validates :memberable_id, presence: true
  validates :memberable_type, presence: true, inclusion: Entityable::ENTITYABLE_CLASSES
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES
  validates :role, presence: true, inclusion: EVENT_ROLES

  before_validation :infer_values

  def infer_values
    self.workflow_state ||= 'active'
    self.role ||= 'attendee'
  end

  def invited?
    workflow_state == 'invited'
  end
end
