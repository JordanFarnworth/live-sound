class EntityUser < ApplicationRecord
  belongs_to :user
  belongs_to :userable, polymorphic: :true

  WORKFLOW_STATES = %w(suspended active)

  validates :user_id, presence: true, uniqueness: { scope: [:userable_id, :userable_type] }
  validates :userable_id, presence: true
  validates :userable_type, presence: true, inclusion: Entityable::ENTITYABLE_CLASSES
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES

  before_validation :infer_values

  def infer_values
    self.workflow_state ||= 'active'
  end
end
