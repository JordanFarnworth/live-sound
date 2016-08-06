class EventMember < ApplicationRecord
  belongs_to :event
  belongs_to :memberable, polymorphic: true

  MEMBER_TYPES = %w(attendee owner performer)
  WORKFLOW_STATES = %w(active removed)

  scope :as_owner, -> { where(member_type: 'owner') }
  scope :as_owner_or_performer, -> { where(member_type: %w(owner performer)) }

  validates :event_id, presence: true
  validates :memberable_id, presence: true
  validates :memberable_type, presence: true, inclusion: MEMBER_TYPES
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES

end
