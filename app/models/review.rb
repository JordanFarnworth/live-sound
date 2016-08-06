class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  belongs_to :reviewerable, polymorphic: true

  WORKFLOW_STATES = %w(published draft)
  REVIEWERABLE = %w(Band Enterprise PrivateParty User)

  validates :text, presence: true
  validates_each :rating do |record, attr, value|
    record.errors.add(attr, 'must be between 1 and 5') if value < 1 || value > 5 || value.nil?
  end
  validates :reviewable_id, presence: true
  validates :reviewable_type, presence: true, inclusion: REVIEWERABLE
  validates :reviewerable_id, presence: true
  validates :reviewerable_type, presence: true, inclusion: REVIEWERABLE
  validates :workflow_state, presence: true, inclusion: WORKFLOW_STATES

end
