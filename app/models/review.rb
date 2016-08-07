class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  belongs_to :reviewerable, polymorphic: true

  WORKFLOW_STATES = %w(unpublished active)

  validates :text, presence: true
  validates :rating, numericality: { in: (1..5) }
  validates :reviewable_id, presence: true, uniqueness: { scope: [:reviewable_type, :reviewerable_id, :reviewerable_type] }
  validates :reviewable_type, presence: true, inclusion: Entityable::ENTITYABLE_CLASSES
  validates :reviewerable_id, presence: true
  validates :reviewerable_type, presence: true, inclusion: Entityable::ENTITYABLE_CLASSES
  validates :reviewerable, presence: true
  validates :reviewable, presence: true
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES

  scope :active, -> { where(workflow_state: 'active') }

  before_validation :infer_values

  def infer_values
    self.workflow_state ||= 'active'
  end
end
