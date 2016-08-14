class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  belongs_to :reviewerable, polymorphic: true

  WORKFLOW_STATES = %w(unpublished active)

  validates :text, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :reviewable_id, presence: true, uniqueness: { scope: [:reviewable_type, :reviewerable_id, :reviewerable_type] }
  validates :reviewable_type, presence: true, inclusion: Entityable::ENTITYABLE_CLASSES
  validates :reviewerable_id, presence: true
  validates :reviewerable_type, presence: true, inclusion: Entityable::ENTITYABLE_CLASSES
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES

end
