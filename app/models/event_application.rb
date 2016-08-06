class EventApplication < ApplicationRecord
  belongs_to :event
  belongs_to :applicable, polymorphic: true

  WORKFLOW_STATES = %w(pending accepted declined)
  APPLICATION_TYPES = %w(as_performer)
  APPLICABLE_TYPES %w(Band User) # for now

  validates :event_id, presence: true
  validates :applicable_id, presence: true
  validates :applicable_type, presence: true, inclusion: APPLICABLE_TYPES
  validates :application_type, presence: true, inclusion: APPLICATION_TYPES
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES

end
