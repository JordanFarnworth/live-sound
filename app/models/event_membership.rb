class EventMembership < ApplicationRecord
  belongs_to :event
  belongs_to :memberable, polymorphic: true

  WORKFLOW_STATES = %w(invitation active_member)
  STATUS_OPTIONS = %w(accepted declined pending)
  EVENT_ROLES = %w(owner admin performer attendee)

  acts_as_paranoid

  scope :as_owner, -> { where(role: 'owner') }
  scope :as_owner_or_admin, -> { where(role: %w(owner admin)) }
  scope :as_owner_or_performer, -> { where(role: %w(owner performer)) }
  scope :invitation, -> { where(workflow_state: 'invitation') }
  scope :active, -> { where(workflow_state: 'active_member') }
  scope :accepted, -> { where(status: 'accepted') }
  scope :declined, -> { where(status: 'declined') }
  scope :pending, -> { where(status: 'pending') }

  validates :event_id, presence: true, uniqueness: { scope: [:memberable_id, :memberable_type, :role] }
  validates :memberable_id, presence: true
  validates :status, presence: true, inclusion: STATUS_OPTIONS
  validates :memberable_type, presence: true, inclusion: Entityable::ENTITYABLE_CLASSES
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES
  validates :role, presence: true, inclusion: EVENT_ROLES

  before_validation :infer_values

  def infer_values
    self.workflow_state ||= 'active_member'
    self.role ||= 'attendee'
    self.status ||= 'accepted'
  end
end
