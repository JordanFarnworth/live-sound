class Favorite < ApplicationRecord
  belongs_to :favoriterable, polymorphic: true
  belongs_to :favoritable, polymorphic: true

  WORKFLOW_STATES = %w(pending accepted declined)
  FAVABLE_TYPES = %w(Band Enterprise PrivateParty User)

  validates :favoriterable_type, presence: true, inclusion: FAVABLE_TYPES
  validates :favoriterable_id, presence: true
  validates :favoritable_type, presence: true, inclusion: FAVABLE_TYPES
  validates :favoritable_id, presence: true
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES
end
