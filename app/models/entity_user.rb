class EntityUser < ApplicationRecord
  belongs_to :user
  belongs_to :userable, polymorphic: :true

  WORKFLOW_STATES = %w(suspended active)
  USERABLE_TYPES = %w(Band User PrivateParty Enterprise) # for now

  validates :user_id, presence: true
  validates :userable_id, presence: true
  validates :userable_type, presence: true, inclusion: USERABLE_TYPES
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES
end
