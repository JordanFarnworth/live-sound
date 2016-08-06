class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  belongs_to :reviewerable, polymorphic: true

  WORKFLOW_STATES = %w(published draft)

  validates :text, presence: true
  validates :rating numericality: { in: (1..5) }
  validates :reviewable_id, presence: true
  validates :reviewable_type, presence: true, inclusion: Entityable::ENTITYABLE_CLASSES
  validates :reviewerable_id, presence: true
  validates :reviewerable_type, presence: true, inclusion: Entityable::ENTITYABLE_CLASSES
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES

end
