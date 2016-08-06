class Favorite < ApplicationRecord
  belongs_to :favoriterable, polymorphic: true
  belongs_to :favoritable, polymorphic: true

  WORKFLOW_STATES = %w(pending accepted declined)

  validates :favoriterable_type, presence: true, inclusion: Entityable::ENTITYABLE_CLASSES
  validates :favoriterable_id, presence: true
  validates :favoritable_type, presence: true, inclusion: Entityable::ENTITYABLE_CLASSES
  validates :favoritable_id, presence: true
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES
end
