class EventMember < ApplicationRecord
  belongs_to :event
  belongs_to :memberable, polymorphic: true

  WORKFLOW_STATES = %w(active pending)
  MEMBER_TYPES = %w(owner performer attendee admin)

  acts_as_paranoid

  scope :as_owner, -> { where(member_type: 'owner') }
  scope :as_owner_or_performer, -> { where(member_type: %w(owner performer)) }

  validates :event_id, presence: true, uniqueness: { scope: [:memberable_id, :memberable_type] }
  validates :memberable_id, presence: true
  validates :memberable_type, presence: true, inclusion: Entityable::ENTITYABLE_CLASSES
  validates :member_type, presence: true, inclusion: MEMBER_TYPES
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES

  before_validation :infer_values

  def infer_values
    self.workflow_state ||= 'active'
  end
end
